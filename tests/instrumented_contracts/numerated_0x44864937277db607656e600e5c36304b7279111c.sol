1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5  
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
8     // benefit is lost if 'b' is also tested.
9     
10     if (a == 0) {
11       return 0;
12     }
13 
14     c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     // uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return a / b;
27   }
28 
29   /**
30   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50   event OwnershipTransferred(
51     address indexed previousOwner,
52     address indexed newOwner
53   );
54 
55   constructor() public {
56     owner = msg.sender;
57   }
58 
59   
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   
66   function transferOwnership(address _newOwner) public onlyOwner {
67     _transferOwnership(_newOwner);
68   }
69 
70   
71   function _transferOwnership(address _newOwner) internal {
72     require(_newOwner != address(0));
73     emit OwnershipTransferred(owner, _newOwner);
74     owner = _newOwner;
75   }
76 }
77 
78 
79 contract Bitcrore is Ownable{
80 using SafeMath for uint256;
81     string public name;
82     string public symbol;
83     uint8 public decimals = 8;
84     uint256 public totalSupply;
85     uint256 public releaseTime;
86     
87     mapping (address => uint256) public balanceOf;
88     mapping (address => mapping (address => uint256)) public allowance;
89     mapping (address => bool) public frozenAccount;
90     
91     event Transfer(address indexed from, address indexed to, uint256 value);
92     event Burn(address indexed from, uint256 value);
93     event FrozenFunds(address target, bool frozen);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 
96     
97     constructor (uint256 initialSupply,string tokenName,string tokenSymbol,uint256 setreleasetime) public
98     {
99         
100         totalSupply = initialSupply;  // Update total supply with the decimal amount
101         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
102         name = tokenName;                                   // Set the name for display purposes
103         symbol = tokenSymbol;   // Set the symbol for display purposes
104         releaseTime = setreleasetime;
105     }
106     
107     function releaseTime(uint256 newreleaseTime) onlyOwner public {
108         releaseTime = newreleaseTime;
109     }
110     
111     function _transfer(address _from, address _to, uint256 _value) internal {
112         // Prevent transfer to 0x0 address. Use burn() instead
113         require(_to != 0x0);
114         // Check if the sender has enough
115         require(balanceOf[_from] >= _value);
116         // Check for overflows
117         require(balanceOf[_to].add(_value) > balanceOf[_to]);
118         // Save this for an assertion in the future
119         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
120         // Subtract from the sender
121         balanceOf[_from] = balanceOf[_from].sub(_value);
122         // Add the same to the recipient
123         balanceOf[_to] = balanceOf[_to].add(_value);
124         emit Transfer(_from, _to, _value);
125         // Asserts are used to use static analysis to find bugs in your code. They should never fail
126         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
127     }
128 
129     function transfer(address _to, uint256 _value) public returns (bool success) {
130         require(now >= releaseTime);
131         require(!frozenAccount[_to]);
132         _transfer(msg.sender, _to, _value);
133         return true;
134     }
135     
136     function allowance( address _owner, address _spender  ) public view returns (uint256)
137     {
138         return allowance[_owner][_spender];
139     }
140   
141     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
142         require(now >= releaseTime);
143         require(!frozenAccount[_from]);
144         require(!frozenAccount[_to]);
145         require(_value <= allowance[_from][msg.sender]);     // Check allowance
146         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
147         _transfer(_from, _to, _value);
148         return true;
149     }
150 
151     function distributeToken(address[] addresses, uint256[] _value) public onlyOwner returns (bool success){
152         //require(msg.sender == owner);
153         assert (addresses.length == _value.length);
154         for (uint i = 0; i < addresses.length; i++) {
155             _transfer(msg.sender, addresses[i], _value[i]);
156         }
157         return true;
158     }
159     
160     function burn(uint256 _value) public onlyOwner returns (bool success) {
161         //require(msg.sender == owner);
162         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
163         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
164         totalSupply =totalSupply.sub(_value);                      // Updates totalSupply
165         emit Burn(msg.sender, _value);
166         emit Transfer(msg.sender, 0x0 , _value);
167         return true;
168     }
169 
170     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
171         //require(msg.sender == owner);
172         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
173         require(!frozenAccount[_from]);
174         require(_value <= allowance[_from][msg.sender]);    // Check allowance
175         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
176         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
177         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
178         emit Burn(_from, _value);
179         emit Transfer(msg.sender, 0x0 , _value);
180         return true;
181     }
182     
183     function freezeAccount(address target, bool freeze) public onlyOwner {
184         frozenAccount[target] = freeze;
185         emit FrozenFunds(target, freeze);
186     }
187     
188     function approve(address _spender, uint256 _value) public returns (bool) {
189         require(!frozenAccount[_spender]);
190         require(!frozenAccount[msg.sender]);
191         allowance[msg.sender][_spender] = _value;
192         emit Approval(msg.sender, _spender, _value);
193         return true;
194     }
195     
196     function increaseApproval( address _spender, uint256 _addedValue) public returns (bool)  {
197         require(!frozenAccount[_spender]);
198         require(!frozenAccount[msg.sender]);
199         allowance[msg.sender][_spender] = (
200         allowance[msg.sender][_spender].add(_addedValue));
201         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
202         return true;
203     }
204   
205     function decreaseApproval( address _spender, uint256 _subtractedValue ) public returns (bool)  {
206         require(!frozenAccount[_spender]);
207         require(!frozenAccount[msg.sender]);
208         uint256 oldValue = allowance[msg.sender][_spender];
209         if (_subtractedValue >= oldValue) {
210           allowance[msg.sender][_spender] = 0;
211         } else {
212           allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213         }
214         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
215         return true;
216     }
217 
218 }