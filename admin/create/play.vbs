Set fso=CreateObject("Scripting.FileSystemObject")
Set hfile=fso.CreateTextFile("create.sql")
hfile.WriteLine(ParseDoc("config.xml", "createtable.xsl"))
hfile.Close

Set hfile=fso.CreateTextFile("tmpcontr.tpl")
hfile.WriteLine(ParseDoc("config.xml", "tools/_script.xsl"))
hfile.Close

Set hfile=fso.CreateTextFile("tmpcontr_ch.tpl")
hfile.WriteLine(ParseDoc("config.xml", "tools/_childscript.xsl"))
hfile.Close

Set hfile=fso.CreateTextFile("tmpcontr_tr.tpl")
hfile.WriteLine(ParseDoc("config.xml", "tools/_treescript.xsl"))
hfile.Close


Set hfile=fso.CreateTextFile("tmp.tpl")
hfile.WriteLine(ParseDoc("config.xml", "createEntity.xsl"))
hfile.Close


Function ParseDoc(XMLDocFileName, XSLDocFileName)
Set source = CreateObject("Msxml2.DOMDocument.3.0")
'MSXML2.DOMDocument
    Source.Async = False
    Source.Load(XMLDocFileName)
Set style = CreateObject("Msxml2.DOMDocument.3.0")
    Style.Async = False
    Style.Load(XSLDocFileName)
ParseDoc = source.transformNode(style)
End Function
