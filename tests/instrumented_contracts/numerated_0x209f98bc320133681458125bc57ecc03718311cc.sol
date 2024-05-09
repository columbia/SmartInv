1 pragma solidity ^0.4.21;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
4         if(a == 0) {
5             return 0;
6         }
7         uint256 c = a * b;
8         assert(c / a == b);
9         return c;
10     }
11     function div(uint256 a, uint256 b) internal pure returns(uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns(uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 contract Ownable {
26     address public owner;
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28     modifier onlyOwner() { require(msg.sender == owner); _; }
29     function Ownable() public { 
30 	    owner = msg.sender; 
31 		}
32     function transferOwnership(address newOwner) public onlyOwner {
33         require(newOwner != address(this));
34         owner = newOwner;
35         emit OwnershipTransferred(owner, newOwner);
36     }
37 }
38 contract bjTest is Ownable {
39     using SafeMath for uint256;
40     uint256 public JoustNum = 1; 
41     uint256 public NumberOfPart = 0; 
42     uint256 public Commission = 0.024 * 1 ether; 
43     uint256 public RateEth = 0.3 * 1 ether; 
44     uint256 public TotalRate = 2.4 * 1 ether; 
45     struct BJJtab { 
46         uint256 JoustNumber;
47         uint256 UserNumber;       
48         address UserAddress; 
49         uint256 CoincidNum;   
50         uint256 Winning; 
51     }
52     mapping(uint256 => mapping(uint256 => BJJtab)) public BJJtable; 
53     struct BJJraundHis{
54         uint256 JoustNum; 
55         uint256 CapAmouth; 
56         uint256 BetOverlap; 
57         string Cap1;
58         string Cap2;
59         string Cap3;
60     }
61     mapping(uint256 => BJJraundHis) public BJJhis;
62     uint256 public AllCaptcha = 0; 
63     uint256 public BetOverlap = 0; 
64     event BJJraund (uint256 UserNum, address User, uint256 CoincidNum, uint256 Winning);
65     event BJJhist (uint256 JoustNum, uint256 CapAllAmouth, uint256 CapPrice, string Cap1, string Cap2, string Cap3);
66     /*Всупление в игру*/
67     function ApushJoustUser(address _address) public onlyOwner{       
68         NumberOfPart += 1;      
69         BJJtable[JoustNum][NumberOfPart].JoustNumber = JoustNum;
70         BJJtable[JoustNum][NumberOfPart].UserNumber = NumberOfPart; 
71         BJJtable[JoustNum][NumberOfPart].UserAddress = _address;
72         BJJtable[JoustNum][NumberOfPart].CoincidNum = 0;
73         BJJtable[JoustNum][NumberOfPart].Winning = 0; 
74         if(NumberOfPart == 8){
75             toAsciiString();
76             NumberOfPart = 0;
77             JoustNum += 1;
78             AllCaptcha = 0;
79         }
80     }
81     function ArJoust(uint256 _n, uint256 _n2) public view returns(uint256){
82         //var Tab = BJJtable[_n][_n2];
83         return BJJtable[_n][_n2].CoincidNum;
84     }    
85     string public Ast;
86     string public Bst;
87     string public Cst;
88     uint256 public  captcha = 0;     
89     uint public gasprice = tx.gasprice;
90     uint public blockdif = block.difficulty;
91     function substring(string str, uint startIndex, uint endIndex, uint256 Jnum, uint256 Usnum) public returns (string) {
92     bytes memory strBytes = bytes(str);
93     bytes memory result = new bytes(endIndex-startIndex);
94     for(uint i = startIndex; i < endIndex; i++) {
95         result[i-startIndex] = strBytes[i];
96         if(keccak256(strBytes[i]) == keccak256(Ast) || keccak256(strBytes[i]) == keccak256(Bst) || keccak256(strBytes[i]) == keccak256(Cst)){ 
97             BJJtable[Jnum][Usnum].CoincidNum += 1; 
98             AllCaptcha += 1;
99         }
100     }
101     return string(result);
102     }
103     uint256 public Winn;
104     function Distribution() public {
105 
106         BetOverlap = (TotalRate - Commission) / AllCaptcha; 
107         BJJhis[JoustNum].JoustNum = JoustNum;
108         BJJhis[JoustNum].CapAmouth = AllCaptcha; 
109         BJJhis[JoustNum].BetOverlap = BetOverlap; 
110         BJJhis[JoustNum].Cap1 = Ast;
111         BJJhis[JoustNum].Cap2 = Bst;
112         BJJhis[JoustNum].Cap3 = Cst;        
113         emit BJJhist(JoustNum, AllCaptcha, BetOverlap, Ast, Bst, Cst);         
114         for(uint i = 1; i<9; i++){
115             BJJtable[JoustNum][i].Winning = BJJtable[JoustNum][i].CoincidNum * BetOverlap;
116             Winn = BJJtable[JoustNum][i].Winning;
117             emit BJJraund(BJJtable[JoustNum][i].UserNumber, BJJtable[JoustNum][i].UserAddress, BJJtable[JoustNum][i].CoincidNum, Winn);
118         }
119     }
120     function toAsciiString() public returns (string) {
121     Random();
122     for(uint a = 1; a < 9; a++){  
123     address x = BJJtable[JoustNum][a].UserAddress; 
124     bytes memory s = new bytes(40);
125     for (uint i = 0; i < 20; i++) {
126         byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
127         byte hi = byte(uint8(b) / 16);
128         byte lo = byte(uint8(b) - 16 * uint8(hi));
129         s[2*i] = char(hi);
130         s[2*i+1] = char(lo);            
131     }
132     substring(string(s), 20, 40, JoustNum, a); 
133     }
134     Distribution();
135     return string(s);
136     }
137 
138     function char(byte b) public pure returns(byte c) {
139         if (b < 10){ return byte(uint8(b) + 0x30); } else {
140             return byte(uint8(b) + 0x57); }
141     }
142     string[] public arrint = ["0","1","2","3","4","5","6","7","8","9"];
143     string[] public arrstr = ["a","b","c","d","e","f"];
144     uint256 public randomA;
145     uint256 public randomB;
146     uint256 public randomC;
147     function Random() public{
148         randomA = uint256(block.blockhash(block.number-1))%9 + 1; //uint
149         randomC = uint256(block.timestamp)%9 +1; //uint
150         randomB = uint256(block.timestamp)%5 +1; // str
151         Ast = arrint[randomA];
152         Cst = arrint[randomC]; 
153         Bst = arrstr[randomB];
154     }   
155     function kill() public onlyOwner {
156         selfdestruct(msg.sender);
157     }
158 
159 }