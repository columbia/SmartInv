1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5  
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
8     // benefit is lost if 'b' is also tested.
9     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
97     constructor (uint256 initialSupply,string tokenName,string tokenSymbol,uint256 _releaseTime) public
98     {
99         releaseTime = _releaseTime;
100         totalSupply = initialSupply;  // Update total supply with the decimal amount
101         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
102         name = tokenName;                                   // Set the name for display purposes
103         symbol = tokenSymbol;                               // Set the symbol for display purposes
104     }
105     
106     function _transfer(address _from, address _to, uint256 _value) internal {
107         // Prevent transfer to 0x0 address. Use burn() instead
108         require(_to != 0x0);
109         // Check if the sender has enough
110         require(balanceOf[_from] >= _value);
111         // Check for overflows
112         require(balanceOf[_to].add(_value) > balanceOf[_to]);
113         // Save this for an assertion in the future
114         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
115         // Subtract from the sender
116         balanceOf[_from] = balanceOf[_from].sub(_value);
117         // Add the same to the recipient
118         balanceOf[_to] = balanceOf[_to].add(_value);
119         emit Transfer(_from, _to, _value);
120         // Asserts are used to use static analysis to find bugs in your code. They should never fail
121         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
122     }
123 
124     function transfer(address _to, uint256 _value) public returns (bool success) {
125         require(now >= releaseTime);
126         require(!frozenAccount[_to]);
127         _transfer(msg.sender, _to, _value);
128         return true;
129     }
130     
131     function allowance( address _owner, address _spender  ) public view returns (uint256)
132     {
133         return allowance[_owner][_spender];
134     }
135   
136     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
137         require(now >= releaseTime);
138         require(!frozenAccount[_from]);
139         require(!frozenAccount[_to]);
140         require(_value <= allowance[_from][msg.sender]);     // Check allowance
141         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
142         _transfer(_from, _to, _value);
143         return true;
144     }
145 
146     function distributeToken(address[] addresses, uint256[] _value) public onlyOwner returns (bool success){
147         //require(msg.sender == owner);
148         assert (addresses.length == _value.length);
149         for (uint i = 0; i < addresses.length; i++) {
150             _transfer(msg.sender, addresses[i], _value[i]);
151         }
152         return true;
153     }
154     
155     function burn(uint256 _value) public onlyOwner returns (bool success) {
156         //require(msg.sender == owner);
157         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
158         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
159         totalSupply =totalSupply.sub(_value);                      // Updates totalSupply
160         emit Burn(msg.sender, _value);
161         emit Transfer(msg.sender, 0x0 , _value);
162         return true;
163     }
164 
165     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
166         //require(msg.sender == owner);
167         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
168         require(!frozenAccount[_from]);
169         require(_value <= allowance[_from][msg.sender]);    // Check allowance
170         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
171         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
172         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
173         emit Burn(_from, _value);
174         emit Transfer(msg.sender, 0x0 , _value);
175         return true;
176     }
177     
178     function freezeAccount(address target, bool freeze) public onlyOwner {
179         frozenAccount[target] = freeze;
180         emit FrozenFunds(target, freeze);
181     }
182     
183     function approve(address _spender, uint256 _value) public returns (bool) {
184         require(!frozenAccount[_spender]);
185         require(!frozenAccount[msg.sender]);
186         allowance[msg.sender][_spender] = _value;
187         emit Approval(msg.sender, _spender, _value);
188         return true;
189     }
190     
191     function increaseApproval( address _spender, uint256 _addedValue) public returns (bool)  {
192         require(!frozenAccount[_spender]);
193         require(!frozenAccount[msg.sender]);
194         allowance[msg.sender][_spender] = (
195         allowance[msg.sender][_spender].add(_addedValue));
196         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
197         return true;
198     }
199   
200     function decreaseApproval( address _spender, uint256 _subtractedValue ) public returns (bool)  {
201         require(!frozenAccount[_spender]);
202         require(!frozenAccount[msg.sender]);
203         uint256 oldValue = allowance[msg.sender][_spender];
204         if (_subtractedValue >= oldValue) {
205           allowance[msg.sender][_spender] = 0;
206         } else {
207           allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208         }
209         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
210         return true;
211     }
212 
213 }