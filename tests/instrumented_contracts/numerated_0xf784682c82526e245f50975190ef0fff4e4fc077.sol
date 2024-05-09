1 pragma solidity 0.4.24;
2 /*
3     Owner
4     owned.sol
5     1.0.1
6 */
7 
8 contract Owned {
9     /* Variables */
10     address public owner = msg.sender;
11     /* Constructor */
12     constructor(address _owner) public {
13         if ( _owner == 0x00 ) {
14             _owner = msg.sender;
15         }
16         owner = _owner;
17     }
18     /* Externals */
19     function replaceOwner(address _owner) external returns(bool) {
20         require( isOwner() );
21         owner = _owner;
22         return true;
23     }
24     /* Internals */
25     function isOwner() internal view returns(bool) {
26         return owner == msg.sender;
27     }
28     /* Modifiers */
29     modifier forOwner {
30         require( isOwner() );
31         _;
32     }
33 }
34 /*
35     Safe mathematical operations
36     safeMath.sol
37     1.0.0
38 */
39 
40 library SafeMath {
41     /* Internals */
42     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
43         c = a + b;
44         assert( c >= a );
45         return c;
46     }
47     function sub(uint256 a, uint256 b) internal pure returns(uint256 c) {
48         c = a - b;
49         assert( c <= a );
50         return c;
51     }
52     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
53         c = a * b;
54         assert( c == 0 || c / a == b );
55         return c;
56     }
57     function div(uint256 a, uint256 b) internal pure returns(uint256) {
58         return a / b;
59     }
60     function pow(uint256 a, uint256 b) internal pure returns(uint256 c) {
61         c = a ** b;
62         assert( c % a == 0 );
63         return a ** b;
64     }
65 }
66 contract TokenDB {}
67 contract Ico {}
68 /*
69     Token Proxy
70     token.sol
71     1.0.2
72 */
73 
74 contract Token is Owned {
75     /* Declarations */
76     using SafeMath for uint256;
77     /* Variables */
78     string  public name = "Inlock token";
79     string  public symbol = "ILK";
80     uint8   public decimals = 8;
81     uint256 public totalSupply = 44e16;
82     address public libAddress;
83     TokenDB public db;
84     Ico public ico;
85     /* Constructor */
86     constructor(address _owner, address _libAddress, address _dbAddress, address _icoAddress) Owned(_owner) public {
87         libAddress = _libAddress;
88         db = TokenDB(_dbAddress);
89         ico = Ico(_icoAddress);
90         emit Mint(_icoAddress, totalSupply);
91     }
92     /* Fallback */
93     function () public { revert(); }
94     /* Externals */
95     function changeLibAddress(address _libAddress) external forOwner {
96         libAddress = _libAddress;
97     }
98     function changeDBAddress(address _dbAddress) external forOwner {
99         db = TokenDB(_dbAddress);
100     }
101     function changeIcoAddress(address _icoAddress) external forOwner {
102         ico = Ico(_icoAddress);
103     }
104     function approve(address _spender, uint256 _value) external returns (bool _success) {
105         address _trg = libAddress;
106         assembly {
107             let m := mload(0x40)
108             calldatacopy(m, 0, calldatasize)
109             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
110             switch success case 0 {
111                 revert(0, 0)
112             } default {
113                 return(m, 0x20)
114             }
115         }
116     }
117     function transfer(address _to, uint256 _amount) external returns (bool _success) {
118         address _trg = libAddress;
119         assembly {
120             let m := mload(0x40)
121             calldatacopy(m, 0, calldatasize)
122             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
123             switch success case 0 {
124                 revert(0, 0)
125             } default {
126                 return(m, 0x20)
127             }
128         }
129     }
130     function bulkTransfer(address[] _to, uint256[] _amount) external returns (bool _success) {
131         address _trg = libAddress;
132         assembly {
133             let m := mload(0x40)
134             calldatacopy(m, 0, calldatasize)
135             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
136             switch success case 0 {
137                 revert(0, 0)
138             } default {
139                 return(m, 0x20)
140             }
141         }
142     }
143     function transferFrom(address _from, address _to, uint256 _amount) external returns (bool _success) {
144         address _trg = libAddress;
145         assembly {
146             let m := mload(0x40)
147             calldatacopy(m, 0, calldatasize)
148             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
149             switch success case 0 {
150                 revert(0, 0)
151             } default {
152                 return(m, 0x20)
153             }
154         }
155     }
156     /* Constants */
157     function allowance(address _owner, address _spender) public view returns (uint256 _remaining) {
158         address _trg = libAddress;
159         assembly {
160             let m := mload(0x40)
161             calldatacopy(m, 0, calldatasize)
162             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
163             switch success case 0 {
164                 revert(0, 0)
165             } default {
166                 return(m, 0x20)
167             }
168         }
169     }
170     function balanceOf(address _owner) public view returns (uint256 _balance) {
171         address _trg = libAddress;
172         assembly {
173             let m := mload(0x40)
174             calldatacopy(m, 0, calldatasize)
175             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
176             switch success case 0 {
177                 revert(0, 0)
178             } default {
179                 return(m, 0x20)
180             }
181         }
182     }
183     /* Events */
184     event AllowanceUsed(address indexed _spender, address indexed _owner, uint256 indexed _value);
185     event Mint(address indexed _addr, uint256 indexed _value);
186     event Approval(address indexed _owner, address indexed _spender, uint _value);
187     event Transfer(address indexed _from, address indexed _to, uint _value);
188 }