1 pragma solidity ^0.4.18;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     emit OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 }
52 
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 contract CJC is ERC20,Ownable{
82   using SafeMath for uint256;
83 
84   //the base info of the token
85   string public constant name="Colour  Jewel Chain";
86   string public constant symbol="CJC";
87   string public constant version = "1.0";
88   uint256 public constant decimals = 18;
89   uint256 public balance;
90 
91   uint256 public constant MAX_SUPPLY=1000000000*10**decimals;
92 
93     struct epoch  {
94         uint256 endTime;
95         uint256 amount;
96     }
97 
98   mapping(address=>epoch[]) public lockEpochsMap;
99     mapping(address => uint256) balances;
100   mapping (address => mapping (address => uint256)) allowed;
101   
102 
103   function CJC() public{
104     totalSupply = MAX_SUPPLY;
105     balances[msg.sender] = MAX_SUPPLY;
106     emit Transfer(0x0, msg.sender, MAX_SUPPLY);
107     balance = 0;
108   }
109 
110 
111 
112   function () payable external
113   {
114       balance = balance.add(msg.value);
115   }
116 
117   function etherProceeds() external
118     onlyOwner
119 
120   {
121     if(!msg.sender.send(balance)) revert();
122     balance = 0;
123   }
124 
125   function lockBalance(address user, uint256 amount,uint256 endTime) external
126     onlyOwner
127   {
128      epoch[] storage epochs = lockEpochsMap[user];
129      epochs.push(epoch(endTime,amount));
130   }
131 
132     function transfer(address _to, uint256 _value) public  returns (bool)
133   {
134     require(_to != address(0));
135     epoch[] storage epochs = lockEpochsMap[msg.sender];
136     uint256 needLockBalance = 0;
137     for(uint256 i=0;i<epochs.length;i++)
138     {
139       if( now < epochs[i].endTime )
140       {
141         needLockBalance=needLockBalance.add(epochs[i].amount);
142       }
143     }
144 
145     require(balances[msg.sender].sub(_value)>=needLockBalance);
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     emit Transfer(msg.sender, _to, _value);
150     return true;
151     }
152 
153     function balanceOf(address _owner) public constant returns (uint256) 
154     {
155     return balances[_owner];
156     }
157 
158 
159     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
160     {
161     require(_to != address(0));
162 
163     epoch[] storage epochs = lockEpochsMap[_from];
164     uint256 needLockBalance = 0;
165     for(uint256 i=0;i<epochs.length;i++)
166     {
167       if( now < epochs[i].endTime )
168       {
169         needLockBalance = needLockBalance.add(epochs[i].amount);
170       }
171     }
172 
173     require(balances[_from].sub(_value)>=needLockBalance);
174     uint256 _allowance = allowed[_from][msg.sender];
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = _allowance.sub(_value);
179     emit Transfer(_from, _to, _value);
180     return true;
181     }
182 
183     function approve(address _spender, uint256 _value) public returns (bool) 
184     {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188     }
189 
190     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) 
191     {
192     return allowed[_owner][_spender];
193     }
194 
195     
196 }