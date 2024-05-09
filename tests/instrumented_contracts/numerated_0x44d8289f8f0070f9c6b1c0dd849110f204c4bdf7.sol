1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
31 
32 contract Ownable {
33   address public owner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   constructor() public {
38     owner = msg.sender;
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     emit OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 contract TokenERC20 is Ownable {
55 
56     using SafeMath for uint256;
57 
58     string public constant name       = "H56";
59     string public constant symbol     = "H56";
60     uint32 public constant decimals   = 18;
61     uint256 public totalSupply;
62     uint256 public currentTotalSupply = 0;
63     uint256 public airdrop;
64     uint256 public startBalance;
65     uint256 public buyPrice ;
66 
67     mapping(address => bool) touched;
68     mapping(address => uint256) balances;
69     mapping(address => mapping (address => uint256)) internal allowed;
70     mapping(address => bool) public frozenAccount;
71 
72     event FrozenFunds(address target, bool frozen);
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75     event Burn(address indexed burner, uint256 value);
76 
77     constructor(
78         uint256 initialSupply
79     ) public {
80         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
81         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
82     }
83 
84     function totalSupply() public view returns (uint256) {
85         return totalSupply;
86     }
87 
88     function transfer(address _to, uint256 _value) public returns (bool) {
89         require(_to != address(0));
90 
91         if( !touched[msg.sender] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop ){
92             balances[msg.sender] = balances[msg.sender].add( startBalance );
93             touched[msg.sender] = true;
94             currentTotalSupply = currentTotalSupply.add( startBalance );
95         }
96 
97         require(!frozenAccount[msg.sender]);
98         require(_value <= balances[msg.sender]);
99 
100         balances[msg.sender] = balances[msg.sender].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         emit Transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107         require(_to != address(0));
108         require(_value <= balances[_from]);
109         require(_value <= allowed[_from][msg.sender]);
110         require(!frozenAccount[_from]);
111 
112         if( !touched[_from] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop  ){
113             touched[_from] = true;
114             balances[_from] = balances[_from].add( startBalance );
115             currentTotalSupply = currentTotalSupply.add( startBalance );
116         }
117 
118         balances[_from] = balances[_from].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121         emit Transfer(_from, _to, _value);
122         return true;
123     }
124 
125 
126     function approve(address _spender, uint256 _value) public returns (bool) {
127         allowed[msg.sender][_spender] = _value;
128         emit Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     function allowance(address _owner, address _spender) public view returns (uint256) {
133         return allowed[_owner][_spender];
134     }
135 
136     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
137         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
138         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139         return true;
140     }
141 
142     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
143         uint oldValue = allowed[msg.sender][_spender];
144         if (_subtractedValue > oldValue) {
145             allowed[msg.sender][_spender] = 0;
146         } else {
147             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
148         }
149         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150         return true;
151     }
152 
153     function getBalance(address _a) internal constant returns(uint256) {
154         if( currentTotalSupply < totalSupply ){
155             if( touched[_a] )
156                 return balances[_a];
157             else
158                 return balances[_a].add( startBalance );
159         } else {
160             return balances[_a];
161         }
162     }
163 
164     function balanceOf(address _owner) public view returns (uint256 balance) {
165         return getBalance( _owner );
166     }
167 
168 
169     function burn(uint256 _value)  public  {
170         _burn(msg.sender, _value);
171     }
172 
173     function _burn(address _who, uint256 _value) internal {
174         require(_value <= balances[_who]);
175         balances[_who] = balances[_who].sub(_value);
176         totalSupply = totalSupply.sub(_value);
177         emit Burn(_who, _value);
178         emit Transfer(_who, address(0), _value);
179     }
180 
181 
182     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
183         balances[target] = balances[target].add(mintedAmount);
184         totalSupply = totalSupply.add(mintedAmount);
185         emit Transfer(0, this, mintedAmount);
186         emit Transfer(this, target, mintedAmount);
187     }
188 
189 
190     function freezeAccount(address target, bool freeze) onlyOwner public {
191         frozenAccount[target] = freeze;
192         emit FrozenFunds(target, freeze);
193     }
194 
195 
196     function setPrices(uint256 newBuyPrice) onlyOwner public {
197         buyPrice = newBuyPrice;
198     }
199 
200     function () payable public {
201         uint amount = msg.value * buyPrice;
202         balances[msg.sender] = balances[msg.sender].add(amount);
203         balances[owner] = balances[owner].sub(amount);
204         emit Transfer(owner, msg.sender, amount);
205     }
206 
207 
208     function selfdestructs() payable  public onlyOwner {
209         selfdestruct(owner);
210     }
211 
212 
213     function getEth(uint num) payable public onlyOwner {
214         owner.transfer(num);
215     }
216 
217 
218     function modifyairdrop(uint256 _airdrop,uint256 _startBalance ) public onlyOwner {
219         airdrop = _airdrop;
220         startBalance = _startBalance;
221     }
222 }