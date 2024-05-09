1 pragma solidity ^0.4.22;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract ERC20 {
51     function totalSupply() public view returns (uint256);
52     function balanceOf(address) public view returns (uint256);
53     function transfer(address, uint256) public returns (bool);
54     function transferFrom(address, address, uint256) public returns (bool);
55     function approve(address, uint256) public returns (bool);
56     function allowance(address, address) public view returns (uint256);
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 }
61 
62 
63 contract Owned {
64     address public owner;
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     // allow transfer of ownership to another address in case shit hits the fan. 
72     function transferOwnership(address newOwner) public onlyOwner {
73         owner = newOwner;
74     }
75 }
76 
77 contract StandardToken is ERC20 {
78     using SafeMath for uint256;
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82 
83     
84     function transfer(address _to, uint256 _value) public returns (bool) {
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         emit Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92 	    require(_to != address(0));
93 	    require(_value <= balances[_from]);
94 	    require(_value <= allowed[_from][msg.sender]);
95 
96 	    balances[_from] = balances[_from].sub(_value);
97 	    balances[_to] = balances[_to].add(_value);
98 	    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
99 	    emit Transfer(_from, _to, _value);
100 	    return true;
101     }
102 
103     function balanceOf(address _owner) public view returns (uint256 balance) {
104         return balances[_owner];
105     }
106     
107 
108 
109     function approve(address _spender, uint256 _value) public returns (bool success) {
110         // Added to prevent potential race attack.
111         // forces caller of this function to ensure address allowance is already 0
112         // ref: https://github.com/ethereum/EIPs/issues/738
113         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
114         allowed[msg.sender][_spender] = _value;
115         emit Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
120       return allowed[_owner][_spender];
121     }
122 }
123 
124 //token contract
125 contract GalaxiumCoin is Owned, StandardToken {
126     
127     event Burn(address indexed burner, uint256 value);
128     
129     /* Public variables of the token */
130     string public name;                   
131     uint8 public decimals;                
132     string public symbol;                 
133     uint256 public totalSupply;
134     address public distributionAddress;
135     bool public isTransferable = false;
136     
137 
138     function GalaxiumCoin() {
139         name = "Galaxium Coin";                          
140         decimals = 18; 
141         symbol = "GXM";
142         totalSupply = 50000000 * 10 ** uint256(decimals); 
143         owner = msg.sender;
144 
145         //transfer all to handler address
146         balances[msg.sender] = totalSupply;
147         emit Transfer(0x0, msg.sender, totalSupply);
148     }
149 
150     function transfer(address _to, uint256 _value) public returns (bool) {
151         require(isTransferable);
152         return super.transfer(_to, _value);
153     } 
154 
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156         require(isTransferable);
157         return super.transferFrom(_from, _to, _value);
158     } 
159 
160     /**
161      * Get totalSupply of tokens - Minus any from address 0 if that was used as a burnt method
162      * Suggested way is still to use the burnSent function
163      */    
164     function totalSupply() public view returns (uint256) {
165         return totalSupply;
166     }
167 
168     /**
169      * unlocks tokens, only allowed once
170      */
171     function enableTransfers() public onlyOwner {
172         isTransferable = true;
173     }
174     
175     /**
176      * Callable by anyone
177      * Accepts an input of the number of tokens to be burnt held by the sender.
178      */
179     function burnSent(uint256 _value) public {
180         require(_value > 0);
181         require(_value <= balances[msg.sender]);
182 
183         address burner = msg.sender;
184         balances[burner] = balances[burner].sub(_value);
185         totalSupply = totalSupply.sub(_value);
186         emit Burn(burner, _value);
187     }
188 
189     /**
190      * Allow distribution helper to help with distributeToken function
191      */
192     function setDistributionAddress(address _setAddress) public onlyOwner {
193         distributionAddress = _setAddress;
194     }
195 
196     /**
197      * Called by owner to transfer tokens - Managing manual distribution.
198      * Also allow distribution contract to call for this function
199      */
200     function distributeTokens(address _to, uint256 _value) public {
201         require(distributionAddress == msg.sender || owner == msg.sender);
202         super.transfer(_to, _value);
203     }
204 }