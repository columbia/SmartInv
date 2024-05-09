1 pragma solidity ^0.5.1;
2 // Saltyness token
3 // Known bug: Doesn't solve the oracle problem. Tweet @ARitzCracker with proof of salt. Saltyness will be sent to the provided address.
4 
5 interface ERC223Handler { 
6     function tokenFallback(address _from, uint _value, bytes calldata _data) external;
7 }
8 
9 contract SaltynessToken{
10     using SafeMath for uint256;
11     using SafeMath for uint;
12     
13 	modifier onlyOwner {
14 		require(msg.sender == owner);
15 		_;
16 	}
17     
18     constructor() public{
19         owner = msg.sender;
20     }
21 	address owner;
22 	address newOwner;
23     
24     mapping(address => uint256) public balanceOf;
25     mapping(address => mapping (address => uint256)) allowances;
26     
27     string constant public name = "Saltyness";
28     string constant public symbol = "SALT";
29     uint8 constant public decimals = 18;
30     uint256 public totalSupply;
31     
32     // --Events
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34     event Transfer(address indexed from, address indexed to, uint value);
35     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
36     // --Events--
37     
38     // --Owner only functions
39     function setNewOwner(address o) public onlyOwner {
40 		newOwner = o;
41 	}
42 
43 	function acceptNewOwner() public {
44 		require(msg.sender == newOwner);
45 		owner = msg.sender;
46 	}
47 	
48     // Known bug: Token supply is theoretically infinite as @peter_szilagyi produces a never-ending stream of salt in extremly high amounts.
49 	function giveSalt(address _saltee, uint256 _salt) public onlyOwner {
50 	    totalSupply = totalSupply.add(_salt);
51 	    balanceOf[_saltee] = balanceOf[_saltee].add(_salt);
52         emit Transfer(address(this), _saltee, _salt, "");
53         emit Transfer(address(this), _saltee, _salt);
54 	}
55 	// --Owner only functions--
56     
57     // --Public write functions
58     function transfer(address _to, uint _value, bytes memory _data, string memory _function) public returns(bool ok){
59         actualTransfer(msg.sender, _to, _value, _data, _function, true);
60         return true;
61     }
62     
63     function transfer(address _to, uint _value, bytes memory _data) public returns(bool ok){
64         actualTransfer(msg.sender, _to, _value, _data, "", true);
65         return true;
66     }
67     function transfer(address _to, uint _value) public returns(bool ok){
68         actualTransfer(msg.sender, _to, _value, "", "", true);
69         return true;
70     }
71     
72     function approve(address _spender, uint _value) public returns (bool success) {
73         allowances[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
78         uint256 _allowance = allowances[_from][msg.sender];
79         require(_allowance > 0, "Not approved");
80         require(_allowance >= _value, "Over spending limit");
81         allowances[_from][msg.sender] = _allowance.sub(_value);
82         actualTransfer(_from, _to, _value, "", "", false);
83         return true;
84     }
85     
86     // --Public write functions--
87      
88     // --Public read-only functions
89     
90     function allowance(address _sugardaddy, address _spender) public view returns (uint remaining) {
91         return allowances[_sugardaddy][_spender];
92     }
93     
94     // --Public read-only functions--
95     
96     
97     
98     // Internal functions
99     
100     function actualTransfer(address _from, address _to, uint _value, bytes memory _data, string memory _function, bool _careAboutHumanity) private{
101         require(balanceOf[_from] >= _value, "Insufficient balance"); // You see, I want to be helpful.
102         require(_to != address(this), "You can't sell back your tokens");
103         
104         // Throwing an exception undos all changes. Otherwise changing the balance now would be a shitshow
105         balanceOf[_from] = balanceOf[_from].sub(_value);
106         balanceOf[_to] = balanceOf[_to].add(_value);
107         
108         if(_careAboutHumanity && isContract(_to)) {
109             if (bytes(_function).length == 0){
110                 ERC223Handler receiver = ERC223Handler(_to);
111                 receiver.tokenFallback(_from, _value, _data);
112             }else{
113                 bool success;
114                 bytes memory returnData;
115                 (success, returnData) = _to.call.value(0)(abi.encodeWithSignature(_function, _from, _value, _data));
116                 assert(success);
117             }
118         }
119         emit Transfer(_from, _to, _value, _data);
120         emit Transfer(_from, _to, _value);
121     }
122     
123     function isContract(address _addr) private view returns (bool is_contract) {
124         uint length;
125         assembly {
126             // Peter hates this opcode because it forces him to realize that it's the only blockchain-related function in the EVM which effects aren't applied until _after_ confirmation.
127             // But no, it's totally a feature as he intended because he is always right.
128             length := extcodesize(_addr)
129         }
130         return (length>0);
131     }
132 }
133 
134 /**
135  * @title SafeMath
136  * @dev Math operations with safety checks that throw on error
137  */
138 library SafeMath {
139     
140     /**
141     * @dev Multiplies two numbers, throws on overflow.
142     */
143     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
144         if (a == 0 || b == 0) {
145            return 0;
146         }
147         c = a * b;
148         assert(c / a == b);
149         return c;
150     }
151     
152     /**
153     * @dev Integer division of two numbers, truncating the quotient.
154     */
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         // assert(b > 0); // Solidity automatically throws when dividing by 0
157         // uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159         return a / b;
160     }
161     
162     /**
163     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
164     */
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         assert(b <= a);
167         return a - b;
168     }
169     
170     /**
171     * @dev Adds two numbers, throws on overflow.
172     */
173     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
174         c = a + b;
175         assert(c >= a);
176         return c;
177     }
178 }