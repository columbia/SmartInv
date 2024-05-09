1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;       
19     }       
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract Ownable {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() public {
41         owner = msg.sender;
42         newOwner = address(0);
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49     modifier onlyNewOwner() {
50         require(msg.sender != address(0));
51         require(msg.sender == newOwner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         require(_newOwner != address(0));
57         newOwner = _newOwner;
58     }
59 
60     function acceptOwnership() public onlyNewOwner returns(bool) {
61         emit OwnershipTransferred(owner, newOwner);        
62         owner = newOwner;
63         newOwner = 0x0;
64     }
65 }
66 
67 contract ERC20 {
68     function totalSupply() public view returns (uint256);
69     function balanceOf(address who) public view returns (uint256);
70     function allowance(address owner, address spender) public view returns (uint256);
71     function transfer(address to, uint256 value) public returns (bool);
72     function transferFrom(address from, address to, uint256 value) public returns (bool);
73     function approve(address spender, uint256 value) public returns (bool);
74 
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 contract Storage{
80 
81     struct LockupInfo {
82         uint256 releaseTime;
83         uint256 termOfRound;
84         uint256 unlockAmountPerRound;        
85         uint256 lockupBalance;
86     }
87 
88     string public name;
89     string public symbol;
90     uint8 constant public decimals =18;
91     uint256 internal initialSupply;
92     uint256 internal totalSupply_;
93 
94     mapping(address => uint256) internal balances;
95     mapping(address => bool) internal locks;
96     mapping(address => bool) public frozen;
97     mapping(address => mapping(address => uint256)) internal allowed;
98     mapping(address => LockupInfo[]) internal lockupInfo;
99 }
100 
101 contract FNBToken is Storage,Ownable,ERC20 {
102 
103     address public implementation;
104 
105     constructor() public {
106         name = "FNB Token";
107         symbol = "FNB";
108         initialSupply = 2500000000; //2,500,000,000 개
109         totalSupply_ = initialSupply * 10 ** uint(decimals);
110         balances[owner] = totalSupply_;
111         emit Transfer(address(0), owner, totalSupply_);
112 
113     }
114     
115     function upgradeTo(address _newImplementation) public onlyOwner {
116         require(implementation != _newImplementation);
117         _setImplementation(_newImplementation);
118     }
119     
120     function totalSupply() public view returns (uint256) {
121         implementationCall();
122     }
123     function balanceOf(address who) public view returns (uint256) {
124         implementationCall();
125     }
126     
127     function allowance(address owner, address spender) public view returns (uint256) {
128         implementationCall();
129     }
130     
131     function transfer(address to, uint256 value) public returns (bool) {
132         implementationCall();
133     }
134     
135     function transferFrom(address from, address to, uint256 value) public returns (bool) {
136         implementationCall();
137     }
138     
139     function approve(address spender, uint256 value) public returns (bool) {
140         implementationCall();
141     }
142     
143     function () payable public {
144         address impl = implementation;
145         require(impl != address(0));
146         assembly {
147             let ptr := mload(0x40)
148             calldatacopy(ptr, 0, calldatasize)
149             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
150             let size := returndatasize
151             returndatacopy(ptr, 0, size)
152             
153             switch result
154             case 0 { revert(ptr, size) }
155             default { return(ptr, size) }
156         }
157     }
158     
159     function implementationCall() internal {
160         address impl = implementation;
161         require(impl != address(0));
162         assembly {
163             let ptr := mload(0x40)
164             calldatacopy(ptr, 0, calldatasize)
165             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
166             let size := returndatasize
167             returndatacopy(ptr, 0, size)
168             
169             switch result
170             case 0 { revert(ptr, size) }
171             default { return(ptr, size) }
172         }
173     }
174 
175     function _setImplementation(address _newImp) internal {
176         implementation = _newImp;
177     }
178 }