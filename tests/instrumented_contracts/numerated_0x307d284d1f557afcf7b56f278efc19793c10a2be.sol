1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-23
3 */
4 
5 pragma solidity ^0.4.21;
6 
7 
8 library SafeMath {
9 
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     if (a == 0) {
12       return 0;
13     }
14     c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     return a / b;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
30     c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
36 
37 contract Ownable {
38   address public owner;
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42   constructor() public {
43     owner = msg.sender;
44   }
45 
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51   function transferOwnership(address newOwner) public onlyOwner {
52     require(newOwner != address(0));
53     emit OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 contract TokenERC20 is Ownable {
60 
61     using SafeMath for uint256;
62 
63     string public constant name       = "Gold Coin";
64     string public constant symbol     = "GC";
65     uint32 public constant decimals   = 18;
66     uint256 public totalSupply;
67     uint256 public currentTotalSupply = 0;
68     uint256 public airdrop;
69     uint256 public startBalance;
70     uint256 public buyPrice ;
71 
72     mapping(address => bool) touched;
73     mapping(address => uint256) balances;
74     mapping(address => mapping (address => uint256)) internal allowed;
75     mapping(address => bool) public frozenAccount;
76 
77     event FrozenFunds(address target, bool frozen);
78     event Transfer(address indexed from, address indexed to, uint256 value);
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80     event Burn(address indexed burner, uint256 value);
81 
82     constructor(
83         uint256 initialSupply
84     ) public {
85         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
86         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
87     }
88 
89     function totalSupply() public view returns (uint256) {
90         return totalSupply;
91     }
92 
93     function transfer(address _to, uint256 _value) public returns (bool) {
94         require(_to != address(0));
95 
96         if( !touched[msg.sender] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop ){
97             balances[msg.sender] = balances[msg.sender].add( startBalance );
98             touched[msg.sender] = true;
99             currentTotalSupply = currentTotalSupply.add( startBalance );
100         }
101 
102         require(!frozenAccount[msg.sender]);
103         require(_value <= balances[msg.sender]);
104 
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         emit Transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112         require(_to != address(0));
113         require(_value <= balances[_from]);
114         require(_value <= allowed[_from][msg.sender]);
115         require(!frozenAccount[_from]);
116 
117         if( !touched[_from] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop  ){
118             touched[_from] = true;
119             balances[_from] = balances[_from].add( startBalance );
120             currentTotalSupply = currentTotalSupply.add( startBalance );
121         }
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         emit Transfer(_from, _to, _value);
127         return true;
128     }
129 
130 
131     function approve(address _spender, uint256 _value) public returns (bool) {
132         allowed[msg.sender][_spender] = _value;
133         emit Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) public view returns (uint256) {
138         return allowed[_owner][_spender];
139     }
140 
141     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
142         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
143         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144         return true;
145     }
146 
147     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
148         uint oldValue = allowed[msg.sender][_spender];
149         if (_subtractedValue > oldValue) {
150             allowed[msg.sender][_spender] = 0;
151         } else {
152             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
153         }
154         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155         return true;
156     }
157 
158     function getBalance(address _a) internal constant returns(uint256) {
159         if( currentTotalSupply < totalSupply ){
160             if( touched[_a] )
161                 return balances[_a];
162             else
163                 return balances[_a].add( startBalance );
164         } else {
165             return balances[_a];
166         }
167     }
168 
169     function balanceOf(address _owner) public view returns (uint256 balance) {
170         return getBalance( _owner );
171     }
172 
173 
174     function burn(uint256 _value)  public  {
175         _burn(msg.sender, _value);
176     }
177 
178     function _burn(address _who, uint256 _value) internal {
179         require(_value <= balances[_who]);
180         balances[_who] = balances[_who].sub(_value);
181         totalSupply = totalSupply.sub(_value);
182         emit Burn(_who, _value);
183         emit Transfer(_who, address(0), _value);
184     }
185 
186 
187     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
188         balances[target] = balances[target].add(mintedAmount);
189         totalSupply = totalSupply.add(mintedAmount);
190         emit Transfer(0, this, mintedAmount);
191         emit Transfer(this, target, mintedAmount);
192     }
193 
194 
195     function freezeAccount(address target, bool freeze) onlyOwner public {
196         frozenAccount[target] = freeze;
197         emit FrozenFunds(target, freeze);
198     }
199 
200 
201     function setPrices(uint256 newBuyPrice) onlyOwner public {
202         buyPrice = newBuyPrice;
203     }
204 
205     function () payable public {
206         uint amount = msg.value * buyPrice;
207         balances[msg.sender] = balances[msg.sender].add(amount);
208         balances[owner] = balances[owner].sub(amount);
209         emit Transfer(owner, msg.sender, amount);
210     }
211 
212 
213     function selfdestructs() payable  public onlyOwner {
214         selfdestruct(owner);
215     }
216 
217 
218     function getEth(uint num) payable public onlyOwner {
219         owner.transfer(num);
220     }
221 
222 
223     function modifyairdrop(uint256 _airdrop,uint256 _startBalance ) public onlyOwner {
224         airdrop = _airdrop;
225         startBalance = _startBalance;
226     }
227 }