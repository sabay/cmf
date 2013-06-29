<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="utf-8"/>

<xsl:template match="a">&lt;a href="<xsl:value-of select="@href" />" target="<xsl:value-of select="@target" />"><xsl:value-of select="." />&lt;/a></xsl:template>

<xsl:template match="col" mode="sortquerys">
    <xsl:variable name="alias"><xsl:choose>
        <xsl:when test="ref/@alias"><xsl:value-of select="ref/@alias"></xsl:value-of></xsl:when>
        <xsl:otherwise>o_<xsl:value-of select="position()"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
<xsl:choose>
    <xsl:when test="@primary='y'">'_id'</xsl:when>
    <xsl:when test="@isstate='y'">'_state'</xsl:when>
    <xsl:otherwise>'<xsl:if test="@type=6 or @type=10">_str</xsl:if><xsl:value-of select="@name"/>'</xsl:otherwise>
</xsl:choose> => Array('<xsl:choose>
    <xsl:when test="@sortasc"><xsl:value-of select="@sortasc"/></xsl:when>
    <xsl:when test="@type=6"><xsl:value-of select="$alias"/>.<xsl:value-of select="ref/visual"/></xsl:when>
    <xsl:otherwise>a.<xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose>', '<xsl:choose>
    <xsl:when test="@sortdesc"><xsl:value-of select="@sortdesc"/></xsl:when>
    <xsl:when test="@type=6"><xsl:value-of select="$alias"/>.<xsl:value-of select="ref/visual"/></xsl:when>
    <xsl:otherwise>a.<xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose> desc'<xsl:if test="@type=6 or @type=13">, Array(Array('<xsl:value-of select="$alias"/>' => '<xsl:value-of select="ref/table"/>'), 'a.<xsl:value-of select="@name"/> = <xsl:value-of select="$alias"/>.<xsl:value-of select="ref/field"/>')</xsl:if>)<xsl:if test="position()!=last()">,
            </xsl:if>
</xsl:template>

<xsl:template name="visual_selector">
<xsl:param name="visual-style"/>
<xsl:choose><xsl:when test="$visual-style = 'text-short' or $visual-style = 'text-long' or $visual-style = 'text-like'"> LIKE ?</xsl:when>
<xsl:when test="$visual-style = 'select' or $visual-style = 'number' or $visual-style = 'checkbox'"> = ?</xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template match="col|pseudocol" mode="filter_name"><xsl:value-of select="name" /></xsl:template>
<xsl:template match="col[selector/name]" mode="filter_name"><xsl:value-of select="selector/name" /></xsl:template>

<xsl:template match="col|pseudocol[@filt='y']" mode="selector">
        array('f_<xsl:value-of select="@name"/>', array(
            'name'  => '<xsl:apply-templates select="." mode="filter_name"/>',
            'where' => <xsl:choose><xsl:when test="selector/where">'<xsl:copy-of select="selector/where"/>',</xsl:when>
                                   <xsl:when test="@type=6">Array('w_<xsl:value-of select="position()"/>.<xsl:choose>
                                            <xsl:when test="selector/visual != 'select'"><xsl:value-of select="ref/visual" /></xsl:when>
                                            <xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
                                        </xsl:choose> <xsl:call-template name="visual_selector"><xsl:with-param name="visual-style" select="selector/visual"/></xsl:call-template>', Array(array('w_<xsl:value-of select="position()"/>'=>'<xsl:apply-templates select="ref/table"/>'),'a.<xsl:value-of select="@name"/>=w_<xsl:value-of select="position()"/>.<xsl:value-of select="ref/field"/> ')),</xsl:when>
                                   <xsl:otherwise>'a.<xsl:value-of select="@name"/> <xsl:call-template name="visual_selector"><xsl:with-param name="visual-style" select="selector/visual"/></xsl:call-template>',</xsl:otherwise></xsl:choose>
            'visual'=> '<xsl:value-of select="selector/visual"/>'<xsl:if test="@type=6 or @type=10">,
                        'multioptions' => 'f_<xsl:value-of select="@name"/>',<xsl:if test="@type=6">
                        'ref' => array('table' => '<xsl:apply-templates select="ref/table"/>',
                                       'field' => '<xsl:apply-templates select="ref/field"/>',
                                       'visual'=> '<xsl:apply-templates select="ref/visual"/>'<xsl:if test="ref/order">,
                                       'order' => '<xsl:apply-templates select="ref/order"/>'</xsl:if><xsl:if test="selector/optionswhere">,
                                       'where' => '<xsl:apply-templates select="selector/optionswhere"/>'</xsl:if><xsl:if test="ref/none">,
                                       'none' => '<xsl:apply-templates select="ref/none"/>'</xsl:if>)</xsl:if></xsl:if>
            )
        )<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="calccol" mode="selector">
        array('f_<xsl:value-of select="@name"/>', array(
            'name'  => '<xsl:value-of select="name"/>',
            'where' => <xsl:choose><xsl:when test="selector/where">'<xsl:copy-of select="selector/where"/>',</xsl:when>
                                   <xsl:otherwise>'<xsl:value-of select="@name"/> <xsl:call-template name="visual_selector"><xsl:with-param name="visual-style" select="selector/visual"/></xsl:call-template>',</xsl:otherwise></xsl:choose>
            'visual'=> '<xsl:value-of select="selector/visual"/>'<xsl:if test="@type=6 or @type=10">,
                        'multioptions' => 'f_<xsl:value-of select="@name"/>',<xsl:if test="@type=6">
                        'ref' => array('table' => '<xsl:apply-templates select="ref/table"/>',
                                       'field' => '<xsl:apply-templates select="ref/field"/>',
                                       'visual'=> '<xsl:apply-templates select="ref/visual"/>'<xsl:if test="ref/order">,
                                       'order' => '<xsl:apply-templates select="ref/order"/>'</xsl:if><xsl:if test="selector/optionswhere">,
                                       'where' => '<xsl:apply-templates select="selector/optionswhere"/>'</xsl:if><xsl:if test="ref/none">,
                                       'none' => '<xsl:apply-templates select="ref/none"/>'</xsl:if>)</xsl:if></xsl:if>
            )
        )<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="calccol" mode="sortquerys">
    <xsl:variable name="alias"><xsl:choose>
        <xsl:when test="ref/@alias"><xsl:value-of select="ref/@alias"></xsl:value-of></xsl:when>
        <xsl:otherwise>o_<xsl:value-of select="position()"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
            '<xsl:value-of select="@name" />' => array('<xsl:choose>
    <xsl:when test="@sortasc"><xsl:value-of select="@sortasc" disable-output-escaping="yes"/><xsl:text> </xsl:text></xsl:when>
    <xsl:when test="@type=6"><xsl:value-of select="$alias"/>.<xsl:value-of select="ref/visual"/></xsl:when>
    <xsl:when test="@name"><xsl:value-of select="@name"/><xsl:text> </xsl:text></xsl:when>
</xsl:choose>','<xsl:choose>
    <xsl:when test="@sortdesc"><xsl:value-of select="@sortdesc" disable-output-escaping="yes"/> desc<xsl:text> </xsl:text></xsl:when>
    <xsl:when test="@type=6"><xsl:value-of select="$alias"/>.<xsl:value-of select="ref/visual"/></xsl:when>
    <xsl:when test="@name"><xsl:value-of select="@name"/> desc<xsl:text> </xsl:text></xsl:when>
</xsl:choose>'<xsl:if test="@type=6">, array(array('<xsl:value-of select="$alias"/>' => '<xsl:value-of select="ref/table"/>'), '<xsl:choose>
    <xsl:when test="ref/ref_field"><xsl:value-of select="ref/ref_field" /></xsl:when>
    <xsl:otherwise>a.<xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose> = <xsl:value-of select="$alias"/>.<xsl:value-of select="ref/field"/>')</xsl:if>)<xsl:if test="position()!=last()">,
            </xsl:if></xsl:template>

<xsl:template match="col" mode="for_postinsert_update" xml:space="preserve"><xsl:choose><xsl:when test="@type=7 or @type=14">
        $fileutils= new \sabay\Files($this->config);
        $picture = $this->get<xsl:value-of select="@name" />();
        if (is_array($picture)) {
            if ($picture['temp_<xsl:value-of select="@name"/>']) {
                $fileParts = explode('#', $picture['old_<xsl:value-of select="@name"/>']);
                $oldFileName = array_shift($fileParts);
                $ext = explode('.', $oldFileName);
                $ext = array_pop($ext);
                $newFileName = $this->id<xsl:if test="@postfix"> . '<xsl:value-of select="@postfix"/>'</xsl:if> . '_' . substr(time(), -3, 3) . '.' . $ext;
                $dir = $this->config->root() . '/images' . $this->imagePath<xsl:if test="@dir"> . '<xsl:value-of select="@dir"/>'</xsl:if>;
                system('mv ' . $dir . $oldFileName . ' ' . $dir . $newFileName);
                $this->set<xsl:value-of select="@name"/>(implode('#', array_merge(array($newFileName), $fileParts)));
            } else {
                $this->set<xsl:value-of select="@name"/>($fileutils->PicturePost<xsl:if test="@ext = 'y'">Ext</xsl:if>($picture, $picture['old_<xsl:value-of select="@name"/>'],
                                <xsl:if test="@prefix">'<xsl:value-of select="@prefix"/>' . </xsl:if>$this->id<xsl:if test="@postfix"> . '<xsl:value-of select="@postfix"/>'</xsl:if> . '_' . substr(time(), -3, 3), $this->imagePath<xsl:if test="@dir"> . '<xsl:value-of select="@dir"/>'</xsl:if><xsl:if test="width &gt; 0">,
                                <xsl:value-of select="width" /></xsl:if><xsl:if test="height &gt; 0">, <xsl:value-of select="height" /></xsl:if>));
            }
            if ($picture['clr_<xsl:value-of select="@name"/>']) {
                $fileutils->UnlinkFile($picture['old_<xsl:value-of select="@name"/>'], $this->imagePath<xsl:if test="@dir"> . '<xsl:value-of select="@dir"/>'</xsl:if>);
                $this->set<xsl:value-of select="@name"/>(null);
            } elseif (
               ($this->get<xsl:value-of select="@name"/>() != $picture['old_<xsl:value-of select="@name"/>'])
               &amp;&amp; $this->existEvent('_postUpdate<xsl:value-of select="@name"/>')
            ) {
                $this->_postUpdate<xsl:value-of select="@name"/>();
            }
        }
</xsl:when>

<xsl:when test="@isrealstate='y'">
        $this->set<xsl:value-of select="@name"/>($this->getstatus());
</xsl:when>
</xsl:choose></xsl:template>

<xsl:template match="col" mode="refscreate" xml:space="preserve">
        '<xsl:value-of select="@name"/>' => array(<xsl:apply-templates select="enum/option" mode="pair"/>)<xsl:if test="position()!=last()">,</xsl:if></xsl:template>

<xsl:template match="option" mode="pair" xml:space="preserve">
                '<xsl:value-of select="@value"/>' => '<xsl:value-of select="."/>'<xsl:if test="position()!=last()">, </xsl:if></xsl:template>
<xsl:template match="col" mode="enumcreate" xml:space="preserve">
        '<xsl:value-of select="@name"/>' => array(<xsl:apply-templates select="enum/option" mode="pair"/>)<xsl:if test="position()!=last()">,</xsl:if></xsl:template>



<xsl:template match="col[../@parentscript = ../@treechild]" mode="meta_short_list" xml:space="preserve"><xsl:choose><xsl:when test="@primary='y'">'_id'</xsl:when><xsl:when test="@isstate='y'">'_state'</xsl:when><xsl:otherwise>'<xsl:if test="@type=6 or @type=10">_str</xsl:if><xsl:value-of select="@name"/>'</xsl:otherwise></xsl:choose> => '<xsl:value-of select="name"/>'<xsl:if test="position()!=last()">, </xsl:if></xsl:template>
<xsl:template match="calccol" mode="meta_short_list" xml:space="preserve">'<xsl:value-of select="@name"/>' => array('<xsl:value-of select="name"/>', '<xsl:value-of select="@name" />')<xsl:if test="position()!=last()">, </xsl:if></xsl:template>

<xsl:template match="col" mode="meta_short_list" xml:space="preserve"><xsl:choose><xsl:when test="@primary='y'">'_id'</xsl:when><xsl:when test="@isstate='y'">'_state'</xsl:when><xsl:otherwise>'<xsl:if test="@type=6 or @type=10">_str</xsl:if><xsl:value-of select="@name"/>'</xsl:otherwise></xsl:choose> => array('<xsl:value-of select="name"/>', '<xsl:value-of select="@name"/>')<xsl:if test="position()!=last()">, </xsl:if></xsl:template>
<xsl:template match="col" mode="meta_select" xml:space="preserve"><xsl:if test="@primary='y'">'_id' => </xsl:if><xsl:if test="@isstate='y'">'_state' => </xsl:if><xsl:if test="@lastnode='y'">'_last' => </xsl:if>'<xsl:value-of select="@name"/>'<xsl:if test="position()!=last()">, </xsl:if></xsl:template>

<xsl:template match="validator" xml:space="preserve">
                                array('<xsl:value-of select="name"/>', '<xsl:apply-templates select="message"/>'<xsl:if test="params">, <xsl:value-of select="params"/></xsl:if>)<xsl:if test="position()!=last()">, </xsl:if></xsl:template>

<xsl:template match="filter" xml:space="preserve">
                                array('<xsl:value-of select="name"/>'<xsl:if test="params">, <xsl:value-of select="params"/></xsl:if>)<xsl:if test="position()!=last()">, </xsl:if></xsl:template>

<xsl:template match="array_validator">
    <xsl:if test="count(*) > 0">
                                Array('->', Array(
                                            <xsl:apply-templates select="col" mode="meta" />
                                ))
    </xsl:if>
</xsl:template>

<xsl:template match="col|pseudocol" mode="meta" xml:space="preserve">
        '<xsl:value-of select="@name"/>' => array('<xsl:value-of select="@name"/>',
                array('name'      => '<xsl:value-of select="name"/>'<xsl:if test="@type">,
                      'type'      => <xsl:value-of select="@type"/></xsl:if><xsl:if test="@primary='y'">,
                      'primary'   => 'y'</xsl:if><xsl:if test="@parent='y'">,
                      'parent'    => 'y'</xsl:if><xsl:if test="@noform = 'y'">,
              'noform'       => 'y'</xsl:if><xsl:if test="@read_only = 'y'">,
              'read_only' => 'y'</xsl:if><xsl:if test="@internal='y'">,
                      'internal'  => 'y'</xsl:if><xsl:if test="@translate='y'">,
                      'translate'  => 'y'</xsl:if><xsl:if test="@visuality='y'">,
                      'visuality' => 'y'</xsl:if><xsl:if test="@autocomplete='y'">,
                      'autocomplete' => 'y'</xsl:if><xsl:if test="@default">,
                      'default'   => '<xsl:value-of select="@default" />'</xsl:if><xsl:if test="@popup='y'">,
                      'popup'     => 'y'</xsl:if><xsl:if test="@calendar='y'">,
                      'calendar'  => 'y'</xsl:if><xsl:if test="@controller">,
                      'controller'=> '<xsl:value-of select="@controller"/>'</xsl:if><xsl:if test="@rows">,
                      'rows'      => '<xsl:value-of select="@rows"/>'</xsl:if><xsl:if test="@cols">,
                      'cols'      => '<xsl:value-of select="@cols"/>'</xsl:if><xsl:if test="@size">,
                      'size'      => '<xsl:value-of select="@size"/>'</xsl:if><xsl:if test="required">,
                      'required'  => '<xsl:value-of select="required"/>'</xsl:if><xsl:if test="@dir">,
                      'dir'       => '<xsl:value-of select="@dir"/>'</xsl:if><xsl:if test="@type='10'">,
                      'multioptions' => '<xsl:value-of select="@name"/>'</xsl:if><xsl:if test="@type='10' and @radio='y'">,
                      'radio'     => '<xsl:value-of select="@radio"/>'</xsl:if><xsl:if test="width">,
                      'width'     => '<xsl:value-of select="width"/>'</xsl:if><xsl:if test="height">,
                      'height'    => '<xsl:value-of select="height"/>'</xsl:if><xsl:if test="@bitfield='y'">,
                      'bitfield'  => true</xsl:if><xsl:if test="@type='6'">,
                      'multioptions' => '<xsl:value-of select="@name"/>',
                      'ref'       => array('table' => '<xsl:apply-templates select="ref/table"/>',
                                           'field' => '<xsl:apply-templates select="ref/field"/>',
                                           'visual'=> '<xsl:apply-templates select="ref/visual"/>',
                                           'order' => '<xsl:apply-templates select="ref/order"/>'<xsl:if test="ref/where">,
                                       'where' => '<xsl:apply-templates select="ref/where"/>'</xsl:if><xsl:if test="ref/none">,
                                           'none' => '<xsl:apply-templates select="ref/none"/>'</xsl:if>)</xsl:if><xsl:if test="validator or array_validator">,
                      'validators'=> array(<xsl:apply-templates select="validator"/><xsl:apply-templates select="array_validator" />
                      )</xsl:if><xsl:if test="filter">,
                      'filters'   => array(<xsl:apply-templates select="filter"/>
                      )</xsl:if>)
        )<xsl:if test="position()!=last()">,</xsl:if></xsl:template>

<!--

            Array('type', Array('multioptions' => 'type')),
            Array('i_agree', Array('required' => 'agreement_required')),
            Array('usertype', Array()),
            Array('surname', Array('required' => 'lastname required',
                    'validators' => Array(
                        Array('hasLength', 'bad_surname_length', 1, 40),
                        Array('isRegExp', 'bad_surname_chars', '/^\pL+$/u')
                        )
                    )),
            Array('name', Array('required' => 'name required',
                    'validators' => Array(
                        Array('hasLength', 'bad_name_length', 1, 40),
                        Array('isRegExp', 'bad_name_chars', '/^\pL+$/u')
                        )
                    )),

-->

<xsl:template match="col" mode="listinput" xml:space="preserve">
                Array(<xsl:choose><xsl:when test="@primary='y'">'_id'</xsl:when><xsl:when test="@isstate='y'">'_state'</xsl:when><xsl:otherwise>'<xsl:if test="@type=6 or @type=10">_str</xsl:if><xsl:value-of select="@name"/>'</xsl:otherwise></xsl:choose>,Array(
                        'name'=>'<xsl:value-of select="@name"/>'<xsl:if test="@type">,
                        'type'=><xsl:value-of select="@type"/></xsl:if><xsl:if test="validator or array_validator">,
                        'validators' => Array(<xsl:apply-templates select="validator"/><xsl:apply-templates select="array_validator" />
                        )</xsl:if><xsl:if test="filter">,
                        'filters' => Array(<xsl:apply-templates select="filter"/>
                        )</xsl:if>
                        )
                )<xsl:if test="position()!=last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="translateinput" xml:space="preserve">
        '<xsl:value-of select="@name"/>' => array('<xsl:apply-templates select="../@name"/>', '<xsl:apply-templates select="@name"/>')<xsl:if test="position()!=last()">,</xsl:if></xsl:template>


<xsl:template match="col" mode="insert" xml:space="preserve">'<xsl:value-of select="@name"/>' => $this->get<xsl:value-of select="@name"/>()<xsl:if test="position()!=last()">,
                                </xsl:if></xsl:template>

<xsl:template match="col[@parent='y' and not(../@treechild)]" mode="insert" xml:space="preserve">
                        '<xsl:value-of select="@name"/>'=>$pid<xsl:if test="position()!=last()">,</xsl:if></xsl:template>

<xsl:template match="col" mode="meta_default">'<xsl:value-of select="@name"/>' => '<xsl:value-of select="@default"/>'<xsl:if test="position() != last()">,
                        </xsl:if></xsl:template>
<xsl:template match="col[@type=8]" mode="meta_default">'<xsl:value-of select="@name"/>' => 0<xsl:if test="position() != last()">,
                        </xsl:if></xsl:template>

<xsl:template match="col" mode="default" xml:space="preserve">
        $this->set<xsl:value-of select="@name" />('<xsl:value-of select="@default" />');</xsl:template>

<xsl:template match="xmls" xml:space="preserve">
        array('type'=>'<xsl:value-of select="@type"/>','name'=>'<xsl:value-of select="."/>')<xsl:if test="position()!=last()">,</xsl:if></xsl:template>
        
<xsl:template match="col" mode="bitparent" xml:space="preserve">'<xsl:value-of select="@name" />' => array(<xsl:apply-templates select="../col[@bitfield='y' and @bitparent=current()/@name]" mode="meta_select"/>)<xsl:if test="position()!=last()">,
                                  </xsl:if></xsl:template>

<xsl:template match="config/table" mode="create" xml:space="preserve">-----------------------|models/entity/<xsl:value-of select="@name"/>Entity.php|
<xsl:text disable-output-escaping="yes">&lt;</xsl:text>?php
require_once 'lib/Entity.php';
<xsl:if test="col[@type=7 or @type=14]">require_once 'lib/files.php';</xsl:if>

class <xsl:value-of select="@name"/>Entity extends Entity
{
    static public $_meta = array(<xsl:apply-templates select="col|pseudocol" mode="meta"/>);

    static public $_meta_select = array(<xsl:apply-templates select="col[@visuality='y' or @selectible='y']" mode="meta_select"/>);
    public $_meta_short_list = array(<xsl:apply-templates select="col[@visuality='y']|calccol" mode="meta_short_list"/>);
    protected $_meta_enums = array(<xsl:apply-templates select="col[@type=10]" mode="enumcreate"/>);
<!--   static public $_meta_refs=Array(<xsl:apply-templates select="col[@type=6]" mode="refscreate"/>); -->

    protected $_meta_default = array(<xsl:apply-templates select="col[@default or @type=8]" mode="meta_default"/>);

    <xsl:if test="not(@treechild)">static public $_meta_order = array(<xsl:apply-templates select="col[@visuality='y']|calccol" mode="sortquerys"/>);</xsl:if>

    <xsl:if test="not(@treechild)">public $_meta_filter = array(<xsl:apply-templates select="col[@filt='y']|pseudocol[@filt='y']|calccol[@filt='y']" mode="selector"/>);</xsl:if>

    <xsl:if test="col/@input = 'y'">public $_meta_input = array(<xsl:apply-templates select="col[@input='y']" mode="listinput"/>);</xsl:if>

    <xsl:if test="col/@translate = 'y'">
    static public $_meta_translate = array(<xsl:apply-templates select="col[@translate='y']" mode="translateinput"/>);</xsl:if>

    <xsl:if test="col[@type='15']">
    protected $_bitfields = array(<xsl:apply-templates select="col[@type='15']" mode="bitparent"/>);
    </xsl:if>

    public $imagePath = '<xsl:value-of select="@imagepath"/>';
    public $xmls = array(<xsl:apply-templates select="xmls"/>);<xsl:if test="col[@parent='y'] and not(@treechild)">
    protected $pid = null;</xsl:if>

    public function getMeta()
    {
        return self::$_meta;
    }

    public static function getColumnMeta($name)
    {
        return self::$_meta[$name];
    }

    public static function getArrayColumnMeta($name)
    {
        return self::$_meta[$name][1]['validators'][0][1];
    }

    public function getMetaEnums()
    {
        $gettext = new \sabay\GetText(get_class($this) . 'Validator',
                                'ru');
        $translatedEnums = array();
        foreach ($this->_meta_enums as $i => $enum) {
            foreach ($enum as $j => $text) {
                $message = $gettext->getText($text);
                if ($message) {
                    $text = $message;
                }
                $translatedEnums[$i][$j] = $text;
            }
        }
        return $translatedEnums;
    }

    public function insert(<xsl:if test="col[@parent='y'] and not(@treechild)">$pid, </xsl:if>$params=null)
    {<xsl:if test="col[@parent='y'] and not(@treechild)">
        $this->pid = $pid;</xsl:if>
        $this->_aData = array();
        <xsl:apply-templates select="col[@default and not(@internal)]" mode="default" />
        if ($params !== null) {
            $this->_aData = array_merge($this->_aData, $params);
        }
        if ($this->existEvent('_preInsert')) {
            $this->_preInsert();
        }<xsl:if test="col[@type = 15]">
        $this->calculateBitFields();</xsl:if>
        $this->db->insert('<xsl:apply-templates select="@name"/>',
                          array(<xsl:apply-templates select="col[not(@primary) and (not(@internal) or @type=15) and not(@bitfield='y') and not(@type=11 or @type=7 or @type=14 or @isrealstate='y')]" mode="insert"/>));

        $this->id = $this->db->lastInsertId('<xsl:apply-templates select="@name"/>', '<xsl:apply-templates select="col[@primary='y']/@name"/>');
        <xsl:if test="col[@type=11 or @type=7 or @type=14 or @isrealstate='y']"><xsl:if test="col[@type=11]">$this->set<xsl:value-of select="col[@type=11]/@name"/>($this->db->fetchOne('SELECT max(<xsl:value-of select="col[@type=11]/@name"/>) FROM <xsl:apply-templates select="@name"/><xsl:if test="col[@parent='y']"> WHERE <xsl:value-of select="col[@parent='y']/@name"/> = ?</xsl:if>'<xsl:if test="col[@parent='y']">, $this->get<xsl:value-of select="col[@parent='y']/@name"/>()</xsl:if>)+1);</xsl:if>
        <xsl:apply-templates select="col[@type=7 or @type=14 or @isrealstate='y']" mode="for_postinsert_update"/>
        $this->db->update('<xsl:apply-templates select="@name"/>',
                          array(<xsl:apply-templates select="col[@type=11 or @type=7 or @type=14 or @isrealstate='y']" mode="insert"/>),
                          $this->db->quoteInto('<xsl:apply-templates select="col[@primary='y']/@name"/> = ?', $this->id));</xsl:if><xsl:if test="col[@lastnode='y']">
        $this->db->update('<xsl:apply-templates select="@name"/>', array('<xsl:apply-templates select="col[@lastnode='y']/@name"/>'=>0),
                          $this->db->quoteInto('<xsl:value-of select="col[@primary='y']/@name"/> = ?',
                          $this->get<xsl:value-of select="col[@parent='y']/@name"/>()));</xsl:if>

        if ($this->existEvent('_postInsert')) {
            $this->_postInsert();
        }
        return $this->id;
    }

    public function _load($id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        return <xsl:if test="col[@type = 15]">$this->parseBitfields(</xsl:if>$this->db->fetchRow('select * from <xsl:value-of select="@name"/> where <xsl:apply-templates select="col[@primary='y']/@name"/> = ?', $this->id)<xsl:if test="col[@type = 15]">)</xsl:if>;
    }

    public function update(<xsl:if test="col[@parent='y'] and not(@treechild)">$pid, </xsl:if>$id=null, $params=null)
    {<xsl:if test="col[@parent='y'] and not(@treechild)">
        $this->pid = $pid;</xsl:if>
        if ($id !== null) {
            $this->id = $id;
        }
        if ($id !== null) {
            $this->_aData = $this->_load($id);
        }
        if ($params !== null) {
            $this->_aData = array_merge($this->_aData, $params);
        }
        if ($this->existEvent('_preUpdate')) {
            $this->_preUpdate();
        }<xsl:if test="col[@type = 15]">
        $this->calculateBitFields();</xsl:if>
        <xsl:apply-templates select="col[@type=7 or @type=14 or @isrealstate='y']" mode="for_postinsert_update"/>
        $this->db->update('<xsl:apply-templates select="@name"/>',
                          array(<xsl:apply-templates select="col[not(@primary) and not(@parent) and (not(@internal) or @update='y') and not(@bitfield='y')]" mode="insert"/>),
                          $this->db->quoteInto('<xsl:apply-templates select="col[@primary='y']/@name"/> = ?', $this->id));

        if ($this->existEvent('_postUpdate')) {
            $this->_postUpdate();
        }
    }

    public function delete(<xsl:if test="col[@parent='y'] and not(@treechild)">$pid, </xsl:if>$id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        if ($this->existEvent('_preDelete')) {
            $this->_preDelete();
        }<xsl:if test="col[@lastnode='y']">
        $pid = $this->db->fetchOne('select <xsl:apply-templates select="col[@parent='y']/@name"/> from <xsl:apply-templates select="@name"/> where <xsl:apply-templates select="col[@primary='y']/@name"/> = ?', $this->id);
        $childcount = $this->db->fetchOne('select count(*) from <xsl:apply-templates select="@name"/> where <xsl:apply-templates select="col[@parent='y']/@name"/> = ?', $pid);
        if ($childcount == 1) {
            $this->db->update('<xsl:apply-templates select="@name"/>',
                              array('<xsl:apply-templates select="col[@lastnode='y']/@name"/>' => 1),
                              $this->db->quoteInto('<xsl:apply-templates select="col[@primary='y']/@name"/> = ?', $pid));
        }</xsl:if>
        $this->db->delete('<xsl:apply-templates select="@name"/>', $this->db->quoteInto('<xsl:apply-templates select="col[@primary='y']/@name"/> = ?', $this->id));
        <xsl:if test="@treechild">$this->_delSubTree($this->id);</xsl:if>
        if ($this->existEvent('_postDelete')) {
            $this->_postDelete();
        }
    }

<xsl:if test="col[@mainTitle='y'] and not(@parentscript)">
    static public function getMainTitle(&amp;$cmf, $id)
    {
        return $cmf->db->fetchOne('select <xsl:value-of select="col[@mainTitle='y']/@name"/> from <xsl:apply-templates select="@name"/> where <xsl:apply-templates select="col[@primary='y']/@name"/> =?',  $id);
    }
</xsl:if>


<xsl:if test="@treechild">

    public function _delSubTree($id)
    {
        $select = $this->db->select()
                       ->from('<xsl:apply-templates select="@name"/>', array('id' => '<xsl:value-of select="col[@primary='y']/@name"/>'))
                       ->where('<xsl:apply-templates select="col[@parent='y']/@name"/> = ?', $id);
        $rows = $this->db->fetchAll($select);
        foreach($rows as $row) {
            $this->_delSubTree($row['id']);
            $this->db->delete('<xsl:apply-templates select="@name"/>', $this->db->quoteInto('<xsl:apply-templates select="col[@primary='y']/@name"/> = ?', $row['id']));
        }
    }

    public function _calkRealStatus($id)
    {
        $pid = $id;
        $realstate = 1;
        while ($pid > 0) {
            $row = $this->db->fetchRow('SELECT <xsl:apply-templates select="col[@parent='y']/@name"/> as pid, <xsl:apply-templates select="col[@isstate='y']/@name"/> as state FROM <xsl:apply-templates select="@name"/> WHERE <xsl:value-of select="col[@primary='y']/@name"/>=?', $pid);
            if ($row['state']!=1) {
                $realstate = 0;
            }
            $pid = $row['pid'];
        }
        return $realstate;
    }

    public function _SetTreeRealStatus($id,$state)
    {
        $select = $this->db->select()
                       ->from('<xsl:apply-templates select="@name"/>',array('id'=>'<xsl:apply-templates select="col[@primary='y']/@name"/>','status'=>'<xsl:apply-templates select="col[@isstate='y']/@name"/>'))
                       ->where('<xsl:apply-templates select="col[@parent='y']/@name"/>=?',$id);
        $rows = $this->db->fetchAll($select);
        foreach ($rows as $row) {
            if ($row["status"]) {
                $this->_SetTreeRealStatus($row['id'], $state);
            }
            if ($state) {
                $this->db->query('update <xsl:apply-templates select="@name"/> set <xsl:apply-templates select="col[@isrealstate='y']/@name"/>=<xsl:apply-templates select="col[@isstate='y']/@name"/> where <xsl:apply-templates select="col[@primary='y']/@name"/>=?', $row['id']);
            } else {
                $this->db->query('update <xsl:apply-templates select="@name"/> set <xsl:apply-templates select="col[@isrealstate='y']/@name"/>=0 where <xsl:apply-templates select="col[@primary='y']/@name"/>=?', $row['id']);
            }
        }
    }

    public function _getOpenLeafs($id=0,<xsl:text disable-output-escaping="yes">&amp;</xsl:text>$hash)
    {
        if (!$id) {
            return $hash;
        }

        $select = $this->db->select()
                       ->from('<xsl:apply-templates select="@name"/>', array('pid' => '<xsl:apply-templates select="col[@parent='y']/@name"/>'))
                       ->where('<xsl:apply-templates select="col[@primary='y']/@name"/>=?', $id);
        $rows = $this->db->fetchAll($select);
        foreach ($rows as $row) {
            if ($row["pid"]) {
                $this->_getOpenLeafs($row["pid"], $hash);
            }

            $select = $this->db->select()
                           ->from('<xsl:apply-templates select="@name"/>', array('id' => '<xsl:apply-templates select="col[@primary='y']/@name"/>'))
                           ->where('<xsl:apply-templates select="col[@parent='y']/@name"/> = ?', $id);
            $rows = $this->db->fetchAll($select);
            foreach ($rows as $row) {
                array_push($hash, $row['id']);
            }
        }

        return $hash;
    }

    public function vs($id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }

        $this->db->query('UPDATE <xsl:apply-templates select="@name"/>
                          SET <xsl:apply-templates select="col[@isstate='y']/@name"/> = NOT(IFNULL(<xsl:apply-templates select="col[@isstate='y']/@name"/>, FALSE)),
                              <xsl:apply-templates select="col[@isrealstate='y']/@name"/> = <xsl:apply-templates select="col[@isstate='y']/@name"/>
                          WHERE <xsl:apply-templates select="col[@primary='y']/@name"/> = ?', $this->id);

        $this->_SetTreeRealStatus($this->id, $this->getrealstatus());
    }

    public function _preUpdate($id=null, $params=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        if($params &amp;&amp; is_array($params) &amp;&amp; array_key_exists('status',$params))
    {
            $select = $this->db->select()
                       ->from('<xsl:apply-templates select="@name"/>', array('status' => '<xsl:apply-templates select="col[@isstate='y']/@name"/>'))
                       ->where('<xsl:apply-templates select="col[@primary='y']/@name"/> = ?', $this->id);
            $old = $this->db->fetchRow($select);
            if($params['status'] != $old['status']) $this->vs($id);
    }
    }

    public function updateMove($id=null, $params=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
        $a = $this->_load($id);
        $old_parent_id = $a['<xsl:apply-templates select="col[@parent='y']/@name"/>'];
        $parent_id = $params['<xsl:apply-templates select="col[@parent='y']/@name"/>'];
        $ordering = $params['<xsl:apply-templates select="col[@type=11]/@name"/>'];

        $cnt = $this->db->fetchOne('select count(*) from <xsl:apply-templates select="@name"/>
        where <xsl:apply-templates select="col[@parent='y']/@name"/> = ? and <xsl:apply-templates select="col[@primary='y']/@name"/> != ?',
            array(
                $old_parent_id,
                $id));
       if( $cnt==0 )
            $this->db->query('update <xsl:apply-templates select="@name"/> set lastnode=1
            where <xsl:apply-templates select="col[@primary='y']/@name"/> = ?', $old_parent_id);

        $this->db->query('update <xsl:apply-templates select="@name"/> set <xsl:apply-templates select="col[@parent='y']/@name"/> = ?, <xsl:apply-templates select="col[@type=11]/@name"/> = ?
        where <xsl:apply-templates select="col[@primary='y']/@name"/> = ?',
        array(
            $parent_id,
            $ordering,
            $id
            ));
        $this->db->query('update <xsl:apply-templates select="@name"/> set lastnode = 0
        where <xsl:apply-templates select="col[@primary='y']/@name"/> = ?', array($parent_id));
    }
</xsl:if>


<xsl:if test="col[@type=11]">

    public function up($id=null)
    {
        if ($id !== null) {
            $this->id = $id;
        }
<xsl:choose><xsl:when test="col[@parent='y']">
        $old = $this->db->fetchRow('select * from <xsl:apply-templates select="@name"/> where <xsl:apply-templates select="col[@primary='y']/@name"/> =?',  $this->id);

        $parent_id = $old['<xsl:apply-templates select="col[@parent='y']/@name"/>'];
        $_id = $old['<xsl:apply-templates select="col[@type='0']/@name"/>'];
        $order = $old['<xsl:value-of select="col[@type=11]/@name"/>'];

        $new = $this->db->fetchRow('select * from <xsl:apply-templates select="@name"/>
            where <xsl:value-of select="col[@type=11]/@name"/> &lt; ?
                and <xsl:apply-templates select="col[@parent='y']/@name"/> = ?
            order by <xsl:value-of select="col[@type=11]/@name"/> DESC limit 1',  array($order, $parent_id));
                $prev =    $new['<xsl:value-of select="col[@type=11]/@name"/>'];
        $new_id = @$new['<xsl:apply-templates select="col[@type='0']/@name"/>'];

        if($new &amp;&amp; $prev &lt;  $old['<xsl:value-of select="col[@type=11]/@name"/>'])
        {
            $this->db->query('UPDATE <xsl:apply-templates select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=? WHERE <xsl:value-of select="col[@primary='y']/@name"/>=?', array($prev, $_id));
            $this->db->query('UPDATE <xsl:apply-templates select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=? WHERE <xsl:value-of select="col[@primary='y']/@name"/> = ?', array($order, $new_id));
        }
</xsl:when>
<xsl:otherwise>
        $old = $this->db->fetchRow('select * from <xsl:apply-templates select="@name"/> where <xsl:apply-templates select="col[@primary='y']/@name"/> =?',  $this->id);

        $_id = $old['<xsl:apply-templates select="col[@type='0']/@name"/>'];
        $order = $old['<xsl:value-of select="col[@type=11]/@name"/>'];

        $new = $this->db->fetchRow('select * from <xsl:apply-templates select="@name"/>
            where <xsl:value-of select="col[@type=11]/@name"/> &lt; ?
            order by <xsl:value-of select="col[@type=11]/@name"/> DESC limit 1',  array($order));
        $prev =    $new['<xsl:value-of select="col[@type=11]/@name"/>'];
        $new_id = @$new['<xsl:apply-templates select="col[@type='0']/@name"/>'];

        if($new &amp;&amp; $prev &lt;  $old['<xsl:value-of select="col[@type=11]/@name"/>'])
        {
            $this->db->query('UPDATE <xsl:apply-templates select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=? WHERE <xsl:value-of select="col[@primary='y']/@name"/>=?', array($prev, $_id));
            $this->db->query('UPDATE <xsl:apply-templates select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=? WHERE <xsl:value-of select="col[@primary='y']/@name"/> = ?', array($order, $new_id));
        }
</xsl:otherwise>
</xsl:choose>
    }

    public function dn($id = null)
    {
        if ($id !== null) {
            $this->id=$id;
        }
<xsl:choose><xsl:when test="col[@parent='y']">
        $old = $this->db->fetchRow('select * from <xsl:apply-templates select="@name"/> where <xsl:apply-templates select="col[@primary='y']/@name"/> =?',  $this->id);

        $parent_id = $old['<xsl:apply-templates select="col[@parent='y']/@name"/>'];
        $_id = $old['<xsl:apply-templates select="col[@type='0']/@name"/>'];
        $order = $old['<xsl:value-of select="col[@type=11]/@name"/>'];

        $new = $this->db->fetchRow('select * from <xsl:apply-templates select="@name"/>
            where <xsl:value-of select="col[@type=11]/@name"/> > ?
                and <xsl:apply-templates select="col[@parent='y']/@name"/> = ?
            order by <xsl:value-of select="col[@type=11]/@name"/> ASC limit 1',  array($order, $parent_id));
                $next =    $new['<xsl:value-of select="col[@type=11]/@name"/>'];
        $new_id = @$new['<xsl:apply-templates select="col[@type='0']/@name"/>'];

        if($new &amp;&amp; $next >  $old['<xsl:value-of select="col[@type=11]/@name"/>'])
        {
            $this->db->query('UPDATE <xsl:apply-templates select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=? WHERE <xsl:value-of select="col[@primary='y']/@name"/>=?', array($next, $_id));
            $this->db->query('UPDATE <xsl:apply-templates select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=? WHERE <xsl:value-of select="col[@primary='y']/@name"/> = ?', array($order, $new_id));
        }
</xsl:when>
<xsl:otherwise>
        $old = $this->db->fetchRow('select * from <xsl:apply-templates select="@name"/> where <xsl:apply-templates select="col[@primary='y']/@name"/> =?',  $this->id);

        $_id = $old['<xsl:apply-templates select="col[@type='0']/@name"/>'];
        $order = $old['<xsl:value-of select="col[@type=11]/@name"/>'];

        $new = $this->db->fetchRow('select * from <xsl:apply-templates select="@name"/>
            where <xsl:value-of select="col[@type=11]/@name"/> > ?
            order by <xsl:value-of select="col[@type=11]/@name"/> ASC limit 1',  array($order));
                $next =    $new['<xsl:value-of select="col[@type=11]/@name"/>'];
        $new_id = @$new['<xsl:apply-templates select="col[@type='0']/@name"/>'];

        if($new &amp;&amp; $next >  $old['<xsl:value-of select="col[@type=11]/@name"/>'])
        {
            $this->db->query('UPDATE <xsl:apply-templates select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=? WHERE <xsl:value-of select="col[@primary='y']/@name"/>=?', array($next, $_id));
            $this->db->query('UPDATE <xsl:apply-templates select="@name"/> set <xsl:value-of select="col[@type=11]/@name"/>=? WHERE <xsl:value-of select="col[@primary='y']/@name"/> = ?', array($order, $new_id));
        }
</xsl:otherwise>
</xsl:choose>
    }</xsl:if>
}
</xsl:template>

<xsl:template match="config/table" mode="create_model" xml:space="preserve">-----------------------|models/<xsl:value-of select="@classname" />.php|
<xsl:text disable-output-escaping="yes">&lt;</xsl:text>?php
require_once 'models/entity/<xsl:value-of select="@name" />Entity.php';

class <xsl:value-of select="@classname" /> extends <xsl:value-of select="@name" />Entity
{
}
</xsl:template>

<xsl:template match="config">
<xsl:apply-templates select="table[not(@nogen)]" mode="create"/>
<xsl:apply-templates select="table[not(@nogen) and (@classname != '')]" mode="create_model"/>
</xsl:template>

</xsl:stylesheet>

