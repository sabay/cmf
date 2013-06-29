<?php
namespace sabay;
class Files{

    private $config;

    function __construct($config=null)
    {
        $this->config=$config;
    }

    function UnlinkFile($name, $VIRTUAL_IMAGE_PATH)
    {
        list($name) = explode('#', $name);
        $fileName = $this->config->root() . '/images' . $VIRTUAL_IMAGE_PATH . $name;
        if (file_exists($fileName) && ! (is_dir($fileName))) {
            unlink($fileName);
        }
    }

    function PicturePost($fildname, $oldname, $name, $VIRTUAL_IMAGE_PATH, $imageWidth = 0, $imageHeight = 0)
    {
        if (gettype($fildname) == "string") {
            return $this->PicturePost($_FILES[$fildname], $oldname, $name, $VIRTUAL_IMAGE_PATH, $imageWidth, $imageHeight);
        } elseif ($fildname['error'] === UPLOAD_ERR_OK) {
            // use image object instead of it's name (hande when we have an array of files)
            $tmpname = $fildname['tmp_name'];

            if(!file_exists($tmpname)) {
                return $oldname;
            }

            list($width, $height, $type, $attr) = getimagesize($tmpname, $info);

            list($oldFileName) = explode('#', $oldname);
            $fileName = "$name.jpg";
            $filePath = $this->config->root().'/images'.$VIRTUAL_IMAGE_PATH.$fileName;

            if (!rename($tmpname, $filePath)) {
                return $oldname;
            }

            if ($imageWidth && $imageHeight) {
                $resizeResults = $this->resizeImage($filePath, $imageWidth, $imageHeight);

                if($resizeResults === false){
                    return $oldname;
                }

                return $fileName.'#'.$imageWidth.'#'.$imageHeight;
            } else {
                return $fileName.'#'.$width.'#'.$height;
            }

        } else
            return $oldname;
    }

    function PicturePostExt($fildname, $oldname, $name, $VIRTUAL_IMAGE_PATH, $imageWidth = 0, $imageHeight = 0)
    {
        if (gettype($fildname) == "string") {
            return $this->PicturePost($_FILES[$fildname], $oldname, $name, $VIRTUAL_IMAGE_PATH, $imageWidth, $imageHeight);
        } elseif ($fildname['error'] === UPLOAD_ERR_OK) {
            // use image object instead of it's name (hande when we have an array of files)
            $tmpname = $fildname['tmp_name'];

            if(!file_exists($tmpname)) {
                return $oldname;
            }

            list($width, $height, $type, $attr) = getimagesize($tmpname);
            $size = getimagesize($tmpname);
            $width = (isset($size) && isset($size[0])) ? $size[0] : NULL;
            $height = (isset($size) && isset($size[1])) ? $size[1] : NULL;
            $mime = (isset($size) && isset($size['mime'])) ? $size['mime'] : NULL;

            list($oldFileName) = explode('#', $oldname);

            if ($mime) {
                switch ($mime) {
                    case 'image/gif':
                       $fileName = "$name.gif";
                    break;

                    case 'image/png':
                       $fileName = "$name.png";
                    break;

                    default:
                        $fileName = "$name.jpg";
                    break;
                }
            } else {
                $fileName = "$name.jpg";
            }
            $filePath = $this->config->root()."/images{$VIRTUAL_IMAGE_PATH}$fileName";

            if (!rename($tmpname, $filePath)) {
                return $oldname;
            }

            if ($imageWidth && $imageHeight) {
                if ($mime == 'image/gif') {
                    $resizeResults = $this->resizeImageExt($filePath, $imageWidth, $imageHeight, NULL, $width, $height);
                } else {
                    $resizeResults = $this->resizeImage($filePath, $imageWidth, $imageHeight);
                }

                if($resizeResults === false){
                    return $oldname;
                }

                return "$fileName#$imageWidth#$imageHeight";
            } else {
                return "$fileName#$width#$height";
            }

        } else
            return $oldname;
    }

    function FilePost($fildname, $oldname, $name, $VIRTUAL_IMAGE_PATH)
    {
        if (gettype($fildname) == "string") {
            return $this->FilePost($_FILES[$fildname], $oldname, $name, $VIRTUAL_IMAGE_PATH);
        } elseif ($fildname['error'] === UPLOAD_ERR_OK) {
            $tmpname = $fildname['tmp_name'];;
            $remotename =  $fildname['name'];
            if (preg_match('/\.([^\.]+?)$/', $remotename, $p)) {
                if ($oldname) {
                    list($oldname) = explode('#', $oldname);
                    if(file_exists($this->docroot . '/images' . $VIRTUAL_IMAGE_PATH . $oldname) && $oldname!='')
                    @unlink($this->config->root() . '/images' . $VIRTUAL_IMAGE_PATH . $oldname);
                }

                $size = filesize($tmpname);
                $name = $name . '.' . strtolower($p[1]);
                move_uploaded_file($tmpname, $this->config->root() . '/images' . $VIRTUAL_IMAGE_PATH . $name);
                return "$name#$size";
            }
        } else return $oldname;
    }
}
