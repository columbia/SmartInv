1 pragma solidity 0.4.25;
2 
3 /**     ONUP TOKEN AFFILIATE PROJECT THE SECOND EDITION
4         CREATED 2018-11-01 BY DAO DRIVER ETHEREUM
5         ALL PROJECT DETAILS AT https://onup.online         **/
6     
7 library SafeMath{
8     function mul(uint256 a, uint256 b)internal pure returns(uint256){if(a==0){return 0;}uint256 c=a*b;assert(c/a==b);return c;}
9     function div(uint256 a, uint256 b)internal pure returns(uint256){uint256 c=a/b;return c;}
10     function sub(uint256 a, uint256 b)internal pure returns(uint256){assert(b<=a);return a-b;}
11     function add(uint256 a, uint256 b)internal pure returns(uint256){uint256 c=a+b;assert(c>=a);return c;}
12 }
13     
14 contract ERC20{
15     uint256 internal Bank=0;string public constant name="OnUp TOKEN";string public constant symbol="OnUp";
16     uint8  public constant decimals=6;uint256 public price=700000000;uint256 public totalSupply;
17     event Approval(address indexed owner,address indexed spender,uint value);
18     event Transfer(address indexed from,address indexed to,uint value);
19     mapping(address=>mapping(address=>uint256))public allowance;mapping(address=>uint256)public balanceOf;
20     function balanceOf(address who)public constant returns(uint){return balanceOf[who];}
21     function approve(address _spender,uint _value)public{allowance[msg.sender][_spender]=_value; emit Approval(msg.sender,_spender,_value);}
22     function allowance(address _owner,address _spender) public constant returns (uint remaining){return allowance[_owner][_spender];}
23 }
24     
25 contract BETA is ERC20{
26     using SafeMath for uint256;
27     modifier onlyPayloadSize(uint size){require(msg.data.length >= size + 4); _;}
28     address  ref1=0x0000000000000000000000000000000000000000;
29     address  ref2=0x0000000000000000000000000000000000000000;
30     address  ref3=0x0000000000000000000000000000000000000000;
31     address  ref4=0x0000000000000000000000000000000000000000;
32     address  ref5=0x0000000000000000000000000000000000000000;
33     address public owner;
34     address internal constant insdr=0xaB85Cb1087ce716E11dC37c69EaaBc09d674575d;// FEEDER 
35     address internal constant advrt=0x28fF20D2d413A346F123198385CCf16E15295351;// ADVERTISE
36     address internal constant spcnv=0x516e0deBB3dB8C2c087786CcF7653fa0991784b3;// AIRDROPS
37     mapping (address=>address) public referrerOf;
38     mapping (address=>uint256) public prevOf;
39     mapping (address=>uint256) public summOf;
40     
41     constructor()payable public{owner=msg.sender;prevOf[advrt]=6;prevOf[owner]=6;}
42     
43     function()payable public{
44         require(isContract(msg.sender)==false);
45         require(msg.value>=10000000000000000);
46         require(msg.value<=30000000000000000000);
47         if(msg.sender!=insdr){
48             ref1=0x0000000000000000000000000000000000000000; 
49             ref2=0x0000000000000000000000000000000000000000;
50             ref3=0x0000000000000000000000000000000000000000;
51             ref4=0x0000000000000000000000000000000000000000;
52             ref5=0x0000000000000000000000000000000000000000;
53             if(msg.sender!= advrt && msg.sender!=owner){CheckPrivilege();}else{mintTokens();}
54         }else{Bank+=(msg.value.div(100)).mul(90);price=Bank.div(totalSupply);}
55     }
56     
57     function CheckPrivilege()internal{
58         if(msg.value>=25000000000000000000 && prevOf[msg.sender]<6){prevOf[msg.sender]=6;}
59         if(msg.value>=20000000000000000000 && prevOf[msg.sender]<5){prevOf[msg.sender]=5;}
60         if(msg.value>=15000000000000000000 && prevOf[msg.sender]<4){prevOf[msg.sender]=4;}
61         if(msg.value>=10000000000000000000 && prevOf[msg.sender]<3){prevOf[msg.sender]=3;}
62         if(msg.value>= 5000000000000000000 && prevOf[msg.sender]<2){prevOf[msg.sender]=2;} 
63         if(msg.value>=  100000000000000000 && prevOf[msg.sender]<1){prevOf[msg.sender]=1;}
64         if(summOf[msg.sender]>=250000000000000000000 && prevOf[msg.sender]<6){prevOf[msg.sender]=6;}
65 		if(summOf[msg.sender]>=200000000000000000000 && prevOf[msg.sender]<5){prevOf[msg.sender]=5;}
66 		if(summOf[msg.sender]>=150000000000000000000 && prevOf[msg.sender]<4){prevOf[msg.sender]=4;}
67 		if(summOf[msg.sender]>=100000000000000000000 && prevOf[msg.sender]<3){prevOf[msg.sender]=3;}
68 		if(summOf[msg.sender]>= 50000000000000000000 && prevOf[msg.sender]<2){prevOf[msg.sender]=2;}
69 		ref1=referrerOf[msg.sender];if(ref1==0x0000000000000000000000000000000000000000){
70 		ref1=bytesToAddress(msg.data);require(isContract(ref1)==false);require(balanceOf[ref1]>0);require(ref1!=spcnv);
71 		require(ref1!=insdr);referrerOf[msg.sender]=ref1;}
72 		mintTokens();
73     }
74     
75     function mintTokens()internal{
76         uint256 tokens=msg.value.div((price*100).div(70));
77         require(tokens>0);require(balanceOf[msg.sender]+tokens>balanceOf[msg.sender]);
78         uint256 perc=msg.value.div(100);uint256 sif=perc.mul(10);
79         uint256 percair=0;uint256 bonus1=0;uint256 bonus2=0;uint256 bonus3=0;
80         uint256 bonus4=0;uint256 bonus5=0;uint256 minus=10;uint256 airdrop=0;
81         if(msg.sender!=advrt && msg.sender!=owner && msg.sender!=spcnv){
82         if(ref1!=0x0000000000000000000000000000000000000000){summOf[ref1]+=msg.value;
83         if(summOf[ref1]>=250000000000000000000 && prevOf[ref1]<6){prevOf[ref1]=6;}
84 		if(summOf[ref1]>=200000000000000000000 && prevOf[ref1]<5){prevOf[ref1]=5;}
85 		if(summOf[ref1]>=150000000000000000000 && prevOf[ref1]<4){prevOf[ref1]=4;}
86 		if(summOf[ref1]>=100000000000000000000 && prevOf[ref1]<3){prevOf[ref1]=3;}
87 		if(summOf[ref1]>= 50000000000000000000 && prevOf[ref1]<2){prevOf[ref1]=2;}
88 		if(referrerOf[ref1]!=0x0000000000000000000000000000000000000000){ref2=referrerOf[ref1];}
89 		if(referrerOf[ref2]!=0x0000000000000000000000000000000000000000){ref3=referrerOf[ref2];}
90 		if(referrerOf[ref3]!=0x0000000000000000000000000000000000000000){ref4=referrerOf[ref3];}
91 		if(referrerOf[ref4]!=0x0000000000000000000000000000000000000000){ref5=referrerOf[ref4];}
92 		if(prevOf[ref1]>1){sif-=perc;bonus1=perc.mul(2);minus-=2;} 
93         else if(prevOf[ref1]>0){bonus1=perc;minus-=1;}}
94         if(ref2!=0x0000000000000000000000000000000000000000){if(prevOf[ref2]>2){sif-=perc.mul(2);bonus2=perc.mul(2);minus-=2;}
95         else if(prevOf[ref2]>0){sif-=perc;bonus2=perc;minus-=1;}}
96         if(ref3!=0x0000000000000000000000000000000000000000){if(prevOf[ref3]>3){sif-=perc.mul(2);bonus3=perc.mul(2);minus-=2;}
97         else if(prevOf[ref3]>0){sif-=perc;bonus3=perc;minus-=1;}}
98         if(ref4!=0x0000000000000000000000000000000000000000){if(prevOf[ref4]>4){sif-=perc.mul(2);bonus4=perc.mul(2);minus-=2;}
99         else if(prevOf[ref4]>0){sif-=perc;bonus4=perc;minus-=1;}}
100         if(ref5!=0x0000000000000000000000000000000000000000){if(prevOf[ref5]>5){sif-=perc.mul(2);bonus5=perc.mul(2);minus-=2;}
101         else if(prevOf[ref5]>0){sif-=perc;bonus5=perc;minus-=1;}}}
102         if(sif>0){
103             airdrop=sif.div((price*100).div(70));
104             require(airdrop>0);percair=sif.div(100);
105             balanceOf[spcnv]+=airdrop;
106             emit Transfer(this,spcnv,airdrop);
107         }
108         Bank+=(perc + percair).mul(85-minus);
109         totalSupply+=(tokens+airdrop);
110         price=Bank.div(totalSupply);
111         balanceOf[msg.sender]+=tokens;
112         emit Transfer(this,msg.sender,tokens);
113         tokens=0;airdrop=0;
114         owner.transfer(perc.mul(5));
115         advrt.transfer(perc.mul(5));
116         if(bonus1>0){ref1.transfer(bonus1);}
117         if(bonus2>0){ref2.transfer(bonus2);}
118         if(bonus3>0){ref3.transfer(bonus3);}
119         if(bonus4>0){ref4.transfer(bonus4);}
120         if(bonus5>0){ref5.transfer(bonus5);}
121     }
122     
123     function transfer(address _to,uint _value)
124     public onlyPayloadSize(2*32)returns(bool success){
125         require(balanceOf[msg.sender]>=_value);
126         if(_to!=address(this)){
127             if(msg.sender==spcnv){require(_value<20000001);}
128             require(balanceOf[_to]+_value>=balanceOf[_to]);
129             balanceOf[msg.sender] -=_value;
130             balanceOf[_to]+=_value;
131             emit Transfer(msg.sender,_to,_value);
132         }else{
133             require(msg.sender!=spcnv);
134             balanceOf[msg.sender]-=_value;uint256 change=_value.mul(price);
135             require(address(this).balance>=change);
136         if(totalSupply>_value){
137             uint256 plus=(address(this).balance-Bank).div(totalSupply);
138             Bank-=change;totalSupply-=_value;Bank+=(plus.mul(_value));
139             price=Bank.div(totalSupply);
140             emit Transfer(msg.sender,_to,_value);}
141         if(totalSupply==_value){
142             price=address(this).balance.div(totalSupply);
143             price=(price.mul(101)).div(100);totalSupply=0;Bank=0;
144             emit Transfer(msg.sender,_to,_value);
145             owner.transfer(address(this).balance-change);
146         }
147         msg.sender.transfer(change);}
148         return true;
149     }
150     function transferFrom(address _from,address _to,uint _value)
151     public onlyPayloadSize(3*32)returns(bool success){
152         require(balanceOf[_from]>=_value);require(allowance[_from][msg.sender]>=_value);
153         if(_to!=address(this)){
154             if(msg.sender==spcnv){require(_value<20000001);}
155             require(balanceOf[_to]+_value>=balanceOf[_to]);
156             balanceOf[_from]-=_value;balanceOf[_to]+=_value;
157             allowance[_from][msg.sender]-=_value;
158             emit Transfer(_from,_to,_value);
159         }else{
160             require(_from!=spcnv);
161             balanceOf[_from]-=_value;uint256 change=_value.mul(price);
162             require(address(this).balance>=change);
163         if(totalSupply>_value){
164             uint256 plus=(address(this).balance-Bank).div(totalSupply);
165             Bank-=change;
166             totalSupply-=_value;
167             Bank+=(plus.mul(_value));
168             price=Bank.div(totalSupply);
169             emit Transfer(_from,_to,_value);
170             allowance[_from][msg.sender]-=_value;}
171         if(totalSupply==_value){
172             price=address(this).balance.div(totalSupply);
173             price=(price.mul(101)).div(100);totalSupply=0;Bank=0;
174             emit Transfer(_from,_to,_value);allowance[_from][msg.sender]-=_value;
175             owner.transfer(address(this).balance-change);
176         }
177         _from.transfer(change);}
178         return true;
179     }
180     
181     function bytesToAddress(bytes source)internal pure returns(address addr){assembly{addr:=mload(add(source,0x14))}return addr;}
182     
183     function isContract(address addr)internal view returns(bool){uint size;assembly{size:=extcodesize(addr)}return size>0;}
184 }