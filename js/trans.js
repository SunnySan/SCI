var sTrans = '{"version":"","autoConvert":"none","iconAction":"auto","symConvert":true,"inputConvert":"none","fontCustom":{"enable":false,"trad":"PMingLiU,MingLiU,新細明體,細明體","simp":"MSSong,宋体,SimSun"},"urlFilter":{"enable":false,"list":[]},"userPhrase":{"enable":true,"trad":{"iTribe_135":"桃園義興部落","iTribe_136":"優霞雲部落","iTribe_137":"嘎色鬧部落","iTribe_138":"溪口台部落","iTribe_139":"新竹義興部落","iTribe_140":"那羅四部落","iTribe_141":"上水田部落【1】","iTribe_142":"上水田部落【2】","iTribe_143":"大安部落","iTribe_144":"百壽部落","iTribe_145":"桃山部落","iTribe_146":"三叉坑部落","iTribe_147":"達觀部落","iTribe_148":"萬山部落","iTribe_149":"桃源部落","iTribe_150":"勤和部落","iTribe_151":"拉芙蘭部落","iTribe_152":"梅山部落","iTribe_153":"屏東春日部落","iTribe_154":"排灣部落","iTribe_155":"美園部落","iTribe_156":"馬兒部落","iTribe_157":"古樓部落","iTribe_158":"大武部落【1】","iTribe_159":"大武部落【2】","iTribe_160":"佳暮部落","iTribe_161":"阿禮部落","iTribe_162":"分水嶺部落","iTribe_163":"平和部落","iTribe_164":"德卡倫部落","iTribe_165":"松羅部落","iTribe_166":"梵梵部落","iTribe_167":"馬里巴西部落","iTribe_168":"嘉里部落","iTribe_169":"七腳川部落","iTribe_170":"壽豐部落【1】","iTribe_171":"壽豐部落【2】","iTribe_172":"拉加善部落","iTribe_173":"下德武部落","iTribe_174":"達蓋部落","iTribe_175":"巴島力安部落","iTribe_176":"古楓部落","iTribe_177":"卓樂部落","iTribe_178":"振興部落","iTribe_179":"大俱來部落","iTribe_180":"山領榴部落","iTribe_181":"加羅板部落","iTribe_182":"魯加卡斯部落","iTribe_183":"新化部落","iTribe_184":"伊達邵部落","iTribe_185":"松林部落","iTribe_186":"眉原部落","iTribe_187":"潭南部落","iTribe_188":"明德部落"},"simp":{}},"contextMenu":{"enable":true}}';

var jTrans = JSON.parse(sTrans);

function getTrans(s){
	var ss = jTrans.userPhrase.trad[s];
	//console.log("ss=" + ss);
	if (beEmpty(ss)){
		return s;
	}else{
		return ss;
	}
}