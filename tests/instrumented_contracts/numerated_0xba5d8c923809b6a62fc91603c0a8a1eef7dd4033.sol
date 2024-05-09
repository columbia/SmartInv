1 pragma solidity ^0.4.25;
2 
3 /* ONUP TOKEN AFFILIATE PROJECT THE FIRST EDITION
4    CREATED 2018-10-31 BY DAO DRIVER ETHEREUM
5    ALL PROJECT DETAILS AT https://onup.online */
6 
7 library SafeMath{
8     function mul(uint256 a, uint256 b)internal pure returns(uint256){if(a==0){return 0;}uint256 c=a*b;assert(c/a==b);return c;}
9     function div(uint256 a, uint256 b)internal pure returns(uint256){uint256 c=a/b;return c;}
10     function sub(uint256 a, uint256 b)internal pure returns(uint256){assert(b<=a);return a-b;}
11     function add(uint256 a, uint256 b)internal pure returns(uint256){uint256 c=a+b;assert(c>=a);return c;}}
12 contract ERC20{uint256 internal Bank=0;string public constant name="OnUp TOKEN";string public constant symbol="OnUp";
13     uint8  public constant decimals=6; uint256 public price=700000000; uint256 public totalSupply;
14     event Approval(address indexed owner,address indexed spender,uint value);
15     event Transfer(address indexed from,address indexed to,uint value);
16     mapping(address=>mapping(address=>uint256))public allowance; mapping(address=>uint256)public balanceOf;
17     function balanceOf(address who)public constant returns(uint){return balanceOf[who];}
18     function approve(address _spender,uint _value)public{allowance[msg.sender][_spender]=_value; emit Approval(msg.sender,_spender,_value);}
19     function allowance(address _owner,address _spender) public constant returns (uint remaining){return allowance[_owner][_spender];}}
20 contract ALFA is ERC20{using SafeMath for uint256;
21     modifier onlyPayloadSize(uint size){require(msg.data.length >= size + 4); _;}
22     address  ref1=0x0000000000000000000000000000000000000000;
23     address  ref2=0x0000000000000000000000000000000000000000;
24     address  ref3=0x0000000000000000000000000000000000000000;
25     address  ref4=0x0000000000000000000000000000000000000000;
26     address  ref5=0x0000000000000000000000000000000000000000;
27     address public owner;
28     address internal constant insdr=0xaB85Cb1087ce716E11dC37c69EaaBc09d674575d;// FEEDER 
29     address internal constant advrt=0x28fF20D2d413A346F123198385CCf16E15295351;// ADVERTISE
30     address internal constant spcnv=0x516e0deBB3dB8C2c087786CcF7653fa0991784b3;// AIRDROPS
31     mapping (address => address) public referrerOf;
32     mapping (address => uint256) public prevOf;
33     mapping (address => uint256) public summOf;
34     constructor()public payable{owner=msg.sender;prevOf[advrt]=6;prevOf[owner]=6;}
35     function()payable public{
36         require(isContract(msg.sender)==false);
37         require(msg.value >= 10000000000000000);
38         require(msg.value <= 30000000000000000000);
39         if( msg.sender!=insdr ){
40             ref1=0x0000000000000000000000000000000000000000; 
41             ref2=0x0000000000000000000000000000000000000000;
42             ref3=0x0000000000000000000000000000000000000000;
43             ref4=0x0000000000000000000000000000000000000000;
44             ref5=0x0000000000000000000000000000000000000000;
45             if(msg.sender!= advrt && msg.sender!=owner){CheckPrivilege();}else{mintTokens();}
46         }else{Bank+=(msg.value.div(100)).mul(90);price=Bank.div(totalSupply);}}
47     function CheckPrivilege()internal{
48         if(msg.value>=25000000000000000000 && prevOf[msg.sender]<6){prevOf[msg.sender]=6;}
49         if(msg.value>=20000000000000000000 && prevOf[msg.sender]<5){prevOf[msg.sender]=5;}
50         if(msg.value>=15000000000000000000 && prevOf[msg.sender]<4){prevOf[msg.sender]=4;}
51         if(msg.value>=10000000000000000000 && prevOf[msg.sender]<3){prevOf[msg.sender]=3;}
52         if(msg.value>= 5000000000000000000 && prevOf[msg.sender]<2){prevOf[msg.sender]=2;} 
53         if(msg.value>=  100000000000000000 && prevOf[msg.sender]<1){prevOf[msg.sender]=1;}
54         if(summOf[msg.sender]>=250000000000000000000 && prevOf[msg.sender]<6){prevOf[msg.sender]=6;}
55 		if(summOf[msg.sender]>=200000000000000000000 && prevOf[msg.sender]<5){prevOf[msg.sender]=5;}
56 		if(summOf[msg.sender]>=150000000000000000000 && prevOf[msg.sender]<4){prevOf[msg.sender]=4;}
57 		if(summOf[msg.sender]>=100000000000000000000 && prevOf[msg.sender]<3){prevOf[msg.sender]=3;}
58 		if(summOf[msg.sender]>= 50000000000000000000 && prevOf[msg.sender]<2){prevOf[msg.sender]=2;}
59 		ref1=referrerOf[msg.sender];if(ref1==0x0000000000000000000000000000000000000000){
60 		ref1=bytesToAddress(msg.data);require(isContract(ref1)==false);require(balanceOf[ref1]>0);require(ref1!=spcnv);
61 		require(ref1!=insdr);referrerOf[msg.sender]=ref1;}mintTokens();}
62     function mintTokens()internal{
63         uint256 tokens=msg.value.div((price*100).div(70));
64         require(tokens>0);require(balanceOf[msg.sender]+tokens>balanceOf[msg.sender]);
65         uint256 perc=msg.value.div(100);uint256 sif=perc.mul(10);
66         uint256 percair=0;uint256 bonus1=0;uint256 bonus2=0;uint256 bonus3=0;
67         uint256 bonus4=0;uint256 bonus5=0;uint256 minus=10;uint256 airdrop=0;
68         if(msg.sender!=advrt && msg.sender!=owner && msg.sender!=spcnv){
69         if(ref1!=0x0000000000000000000000000000000000000000){summOf[ref1]+=msg.value;
70         if(summOf[ref1]>=250000000000000000000 && prevOf[ref1]<6){prevOf[ref1]=6;}
71 		if(summOf[ref1]>=200000000000000000000 && prevOf[ref1]<5){prevOf[ref1]=5;}
72 		if(summOf[ref1]>=150000000000000000000 && prevOf[ref1]<4){prevOf[ref1]=4;}
73 		if(summOf[ref1]>=100000000000000000000 && prevOf[ref1]<3){prevOf[ref1]=3;}
74 		if(summOf[ref1]>= 50000000000000000000 && prevOf[ref1]<2){prevOf[ref1]=2;} 
75         if(prevOf[ref1]>1){sif-=perc;bonus1=perc.mul(2);minus-=2;} 
76         else if(prevOf[ref1]>0){bonus1=perc;minus-=1;}}
77         if(ref2!=0x0000000000000000000000000000000000000000){if(prevOf[ref2]>2){sif-=perc.mul(2);bonus2=perc.mul(2);minus-=2;}
78         else if(prevOf[ref2]>0){sif-=perc;bonus2=perc;minus-=1;}}
79         if(ref3!=0x0000000000000000000000000000000000000000){if(prevOf[ref3]>3){sif-=perc.mul(2);bonus3=perc.mul(2);minus-=2;}
80         else if(prevOf[ref3]>0){sif-=perc;bonus3=perc;minus-=1;}}
81         if(ref4!=0x0000000000000000000000000000000000000000){if(prevOf[ref4]>4){sif-=perc.mul(2);bonus4=perc.mul(2);minus-=2;}
82         else if(prevOf[ref4]>0){sif-=perc;bonus4=perc;minus-=1;}}
83         if(ref5!=0x0000000000000000000000000000000000000000){if(prevOf[ref5]>5){sif-=perc.mul(2);bonus5=perc.mul(2);minus-=2;}
84         else if(prevOf[ref5]>0){sif-=perc;bonus5=perc;minus-=1;}}}
85         if(sif>0){airdrop=sif.div((price*100).div(70));
86             require(airdrop>0);percair=sif.div(100);
87             balanceOf[spcnv]+=airdrop;
88             emit Transfer(this,spcnv,airdrop);}
89         Bank+=(perc + percair).mul(85-minus);
90         totalSupply+=(tokens+airdrop);
91         price=Bank.div(totalSupply);
92         balanceOf[msg.sender]+=tokens;
93         emit Transfer(this,msg.sender,tokens);
94         tokens=0;airdrop=0;
95         owner.transfer(perc.mul(5));
96         advrt.transfer(perc.mul(5));
97         if(bonus1>0){ref1.transfer(bonus1);}
98         if(bonus2>0){ref2.transfer(bonus2);}
99         if(bonus3>0){ref3.transfer(bonus3);}
100         if(bonus4>0){ref4.transfer(bonus4);}
101         if(bonus5>0){ref5.transfer(bonus5);}}
102     function transfer(address _to,uint _value)
103       public onlyPayloadSize(2*32)returns(bool success){
104         require(balanceOf[msg.sender]>=_value);
105         if(_to!=address(this)){
106             if(msg.sender==spcnv){require(_value<20000001);}
107             require(balanceOf[_to]+_value>=balanceOf[_to]);
108             balanceOf[msg.sender] -=_value;
109             balanceOf[_to]+=_value;
110             emit Transfer(msg.sender,_to,_value);
111         }else{require(msg.sender!=spcnv);
112         balanceOf[msg.sender]-=_value;uint256 change=_value.mul(price);
113         require(address(this).balance>=change);
114         if(totalSupply>_value){
115             uint256 plus=(address(this).balance-Bank).div(totalSupply);
116             Bank-=change;totalSupply-=_value;Bank+=(plus.mul(_value));
117             price=Bank.div(totalSupply);
118             emit Transfer(msg.sender,_to,_value);}
119         if(totalSupply==_value){
120             price=address(this).balance.div(totalSupply);
121             price=(price.mul(101)).div(100);totalSupply=0;Bank=0;
122             emit Transfer(msg.sender,_to,_value);
123             owner.transfer(address(this).balance-change);}
124         msg.sender.transfer(change);}return true;}
125     function transferFrom(address _from,address _to,uint _value)
126     public onlyPayloadSize(3*32)returns(bool success){
127         require(balanceOf[_from]>=_value);require(allowance[_from][msg.sender]>=_value);
128         if(_to!=address(this)){
129             if(msg.sender==spcnv){require(_value<20000001);}
130             require(balanceOf[_to]+_value>=balanceOf[_to]);
131             balanceOf[_from]-=_value;balanceOf[_to]+=_value;
132             allowance[_from][msg.sender]-=_value;
133             emit Transfer(_from,_to,_value);
134         }else{require(_from!=spcnv);
135         balanceOf[_from]-=_value;uint256 change=_value.mul(price);
136         require(address(this).balance>=change);
137         if(totalSupply>_value){
138             uint256 plus=(address(this).balance-Bank).div(totalSupply);
139             Bank-=change;
140             totalSupply-=_value;
141             Bank+=(plus.mul(_value));
142             price=Bank.div(totalSupply);
143             emit Transfer(_from,_to,_value);
144             allowance[_from][msg.sender]-=_value;}
145         if(totalSupply==_value){
146             price=address(this).balance.div(totalSupply);
147             price=(price.mul(101)).div(100);totalSupply=0;Bank=0;
148             emit Transfer(_from,_to,_value);allowance[_from][msg.sender]-=_value;
149             owner.transfer(address(this).balance-change);}
150             _from.transfer(change);}return true;}
151     function bytesToAddress(bytes source)internal pure returns(address addr){assembly{addr:=mload(add(source,0x14))}return addr;}
152     function isContract(address addr)internal view returns(bool){uint size;assembly{size:=extcodesize(addr)}return size>0;}
153 }