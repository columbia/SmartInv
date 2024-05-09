1 pragma solidity 0.5.13;
2 library SafeMath{
3 	function div(uint256 a,uint256 b)internal pure returns(uint256){require(b>0);uint256 c=a/b;return c;}
4 	function mul(uint256 a,uint256 b)internal pure returns(uint256){if(a==0){return 0;}uint256 c=a*b;require(c/a==b);return c;}}
5 interface Out{
6 	function mint(address w,uint256 a)external returns(bool);
7 	function bonus(address w,uint256 a)external returns(bool);
8     function burn(address w,uint256 a)external returns(bool);
9     function await(address w,uint256 a)external returns(bool);
10     function subsu(uint256 a)external returns(bool);
11 	function ref(address a)external view returns(address);
12     function sef(address a)external view returns(address);
13     function bct()external view returns(uint256);
14     function act()external view returns(uint256);
15 	function amem(uint256 i)external view returns(address);
16 	function bmem(uint256 i)external view returns(address);
17 	function deal(address w,address g,address q,address x,uint256 a,uint256 e,uint256 s,uint256 z)external returns(bool);}
18 contract TOTAL{
19 	using SafeMath for uint256;
20 	modifier onlyOwn{require(own==msg.sender);_;}
21     address private own; address private rot;
22     address private reg; address private rvs;
23     address private uni; address private del;
24 	function()external{revert();}
25 	function jmining(uint256 a,uint256 c)external returns(bool){
26 	address g = Out(reg).ref(msg.sender);
27 	address x = Out(reg).sef(msg.sender); 
28 	require(a>999999&&Out(rot).burn(msg.sender,a));
29 	if(c==1){require(Out(rot).mint(rvs,a.div(100).mul(75)));}else 
30 	if(c==2){require(Out(rot).subsu(a.div(100).mul(75)));}else{
31 	if(x==msg.sender&&g==x){require(Out(rot).mint(x,a.div(100).mul(75)));}else{
32 	uint256 aaa=a.div(100).mul(75);address _awn;address _bwn;
33 	uint256 an=Out(uni).act();uint256 bn=Out(uni).bct();
34 	uint256 mm=aaa.div(5);uint256 am=mm.div(an).mul(4);uint256 bm=mm.div(bn);
35 	for(uint256 j=0;j<an;j++){_awn=Out(uni).amem(j);require(Out(rot).mint(_awn,am));}
36 	for(uint256 j=0;j<bn;j++){_bwn=Out(uni).bmem(j);require(Out(rot).mint(_bwn,bm));}}}
37 	require(Out(del).deal(msg.sender,address(0),g,x,a,0,0,0)&&
38 	Out(rot).mint(g,a.div(100).mul(20))&&Out(rot).mint(x,a.div(100).mul(5))&&
39 	Out(del).bonus(g,a.div(100).mul(20))&&Out(del).bonus(x,a.div(100).mul(5))&&
40 	Out(del).await(msg.sender,a.mul(9))&&Out(del).await(g,a.div(2))&&
41 	Out(del).await(x,a.div(2)));return true;}
42 	function setreg(address a)external onlyOwn returns(bool){reg=a;return true;}
43 	function setrot(address a)external onlyOwn returns(bool){rot=a;return true;}	
44 	function setdel(address a)external onlyOwn returns(bool){del=a;return true;}
45 	function setuni(address a)external onlyOwn returns(bool){uni=a;return true;}
46 	constructor()public{own=msg.sender;rvs=0xd8E399398839201C464cda7109b27302CFF0CEaE;}}