1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
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
34 /**
35 * @dev Open Zepelin Standard token contract
36 */
37 contract StandardToken {
38     using SafeMath for uint256;
39 
40     uint256 public totalSupply;
41 
42     mapping(address => uint256) balances;
43     mapping (address => mapping (address => uint256)) internal allowed;
44 
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /**
49     * @dev transfer token for a specified address
50     * @param _to The address to transfer to.
51     * @param _value The amount to be transferred.
52     */
53     function transfer(address _to, uint256 _value) public returns (bool) {
54         require(_to != address(0));
55         require(_value <= balances[msg.sender]);
56 
57         // SafeMath.sub will throw if there is not enough balance.
58         balances[msg.sender] = balances[msg.sender].sub(_value);
59         balances[_to] = balances[_to].add(_value);
60         Transfer(msg.sender, _to, _value);
61         return true;
62     }
63 
64     /**
65     * @dev Gets the balance of the specified address.
66     * @param _owner The address to query the the balance of.
67     * @return An uint256 representing the amount owned by the passed address.
68     */
69     function balanceOf(address _owner) public view returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     /**
74      * @dev Transfer tokens from one address to another
75      * @param _from address The address which you want to send tokens from
76      * @param _to address The address which you want to transfer to
77      * @param _value uint256 the amount of tokens to be transferred
78      */
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81         require(_value <= balances[_from]);
82         require(_value <= allowed[_from][msg.sender]);
83 
84         balances[_from] = balances[_from].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87         Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     /**
92      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
93      *
94      * Beware that changing an allowance with this method brings the risk that someone may use both the old
95      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
96      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
97      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98      * @param _spender The address which will spend the funds.
99      * @param _value The amount of tokens to be spent.
100      */
101     function approve(address _spender, uint256 _value) public returns (bool) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     /**
108      * @dev Function to check the amount of tokens that an owner allowed to a spender.
109      * @param _owner address The address which owns the funds.
110      * @param _spender address The address which will spend the funds.
111      * @return A uint256 specifying the amount of tokens still available for the spender.
112      */
113     function allowance(address _owner, address _spender) public view returns (uint256) {
114         return allowed[_owner][_spender];
115     }
116 }
117 
118 
119 contract MomsAvenueToken is StandardToken {
120 
121     string public constant name = "M.O.M.";
122     string public constant symbol = "MOM";
123     uint8 public constant decimals = 18;
124 
125     address public owner;
126 
127     uint256 public constant totalSupply = 2200000000 * (10 ** uint256(decimals));
128     uint256 public constant lockedAmount = 990000000 * (10 ** uint256(decimals));
129 
130     uint256 public lockReleaseTime;
131 
132     bool public allowTrading = false;
133 
134     function MomsAvenueToken() public {
135         owner = msg.sender;
136         balances[owner] = totalSupply;
137         lockReleaseTime = now + 1 years;
138     }
139 
140     function transfer(address _to, uint256 _value) public returns (bool) {
141         if (!allowTrading) {
142             require(msg.sender == owner);
143         }
144         
145         //Do not allow owner to spend locked amount until lock is released
146         if (msg.sender == owner && now < lockReleaseTime) {
147             require(balances[msg.sender].sub(_value) >= lockedAmount); 
148         }
149 
150         return super.transfer(_to, _value);
151     }
152 
153     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154         if (!allowTrading) {
155             require(_from == owner);
156         }
157 
158         //Do not allow owner to spend locked amount until lock is released
159         if (_from == owner && now < lockReleaseTime) {
160             require(balances[_from].sub(_value) >= lockedAmount); 
161         }
162 
163         return super.transferFrom(_from, _to, _value);
164     }
165 
166     function setAllowTrading(bool _allowTrading) public {
167         require(msg.sender == owner);
168         allowTrading = _allowTrading;
169     }
170 }