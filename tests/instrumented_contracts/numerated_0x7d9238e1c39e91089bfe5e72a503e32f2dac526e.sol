1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 interface tokenRecipient {
35     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
36 }
37 
38 
39 contract ERC20 {
40     uint256 public totalSupply;
41     function balanceOf(address owner) public constant returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44     function approve(address spender, uint256 value) public returns (bool);
45     function allowance(address owner, address spender) public constant returns (uint256);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 
51 contract StandardToken is ERC20 {
52     using SafeMath for uint256;
53 
54     mapping(address => uint256) balances;
55     mapping (address => mapping (address => uint256)) internal allowed;
56 
57     /**
58      * @dev Gets the balance of the specified address.
59      * @param _owner The address to query the the balance of.
60      * @return An uint256 representing the amount owned by the passed address.
61      */
62     function balanceOf(address _owner) public constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     /**
67      * @dev transfer token for a specified address
68      * @param _to The address to transfer to.
69      * @param _value The amount to be transferred.
70      */
71     function transfer(address _to, uint256 _value) public returns (bool) {
72         require(_to != address(0));
73         require(_value <= balances[msg.sender]);
74 
75         // SafeMath.sub will throw if there is not enough balance.
76         balances[msg.sender] = balances[msg.sender].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     /**
83      * @dev Transfer tokens from one address to another
84      * @param _from address The address which you want to send tokens from
85      * @param _to address The address which you want to transfer to
86      * @param _value uint256 the amount of tokens to be transferred
87      */
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89         require(_to != address(0));
90         require(_value <= balances[_from]);
91         require(_value <= allowed[_from][msg.sender]);
92 
93         balances[_from] = balances[_from].sub(_value);
94         balances[_to] = balances[_to].add(_value);
95         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
96         Transfer(_from, _to, _value);
97         return true;
98     }
99 
100     /**
101      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
102      * @param _spender The address which will spend the funds.
103      * @param _value The amount of tokens to be spent.
104      */
105     function approve(address _spender, uint256 _value) public returns (bool) {
106         // To change the approve amount you first have to reduce the addresses`
107         //  allowance to zero by calling `approve(_spender, 0)` if it is not
108         //  already 0 to mitigate the race condition described here:
109         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
111         allowed[msg.sender][_spender] = _value;
112         Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     /**
117      * @dev approve should be called when allowed[_spender] == 0. To increment
118      * allowed value is better to use this function to avoid 2 calls (and wait until
119      * the first transaction is mined)
120      * From MonolithDAO Token.sol
121      * @param _spender The address which will spend the funds
122      * @param _addedValue The amount of tokens to be added to the spender's funds.
123      */
124     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
125         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
126         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127         return true;
128     }
129 
130     /**
131      * @param _spender The address which will spend the funds
132      * @param _subtractedValue The amount of tokens to be subtracted from the spender's funds.
133      */
134     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
135         uint oldValue = allowed[msg.sender][_spender];
136         if (_subtractedValue > oldValue) {
137             allowed[msg.sender][_spender] = 0;
138         } else {
139             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
140         }
141         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142         return true;
143     }
144 
145     /**
146      * @dev Function to check the amount of tokens that an owner allowed to a spender.
147      * @param _owner address The address which owns the funds.
148      * @param _spender address The address which will spend the funds.
149      * @return A uint256 specifying the amount of tokens still available for the spender.
150      */
151     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
152         return allowed[_owner][_spender];
153     }
154 
155     /**
156      * Set allowance for other address and notify
157      * @dev Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
158      * @param _spender The address authorized to spend
159      * @param _value the max amount they can spend
160      * @param _extraData some extra information to send to the approved contract
161      */
162     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
163         tokenRecipient spender = tokenRecipient(_spender);
164         if (approve(_spender, _value)) {
165             spender.receiveApproval(msg.sender, _value, this, _extraData);
166             return true;
167         }
168     }
169 }
170 
171 
172 contract ChickenToken is StandardToken {
173     string public constant name = "ChickenToken";
174     string public constant symbol = "CHKN";
175     uint256 public decimals = 8;
176     uint256 public totalSupply = 6772757848484848;
177 
178     function ChickenToken() public {
179         balances[msg.sender] = totalSupply;
180     }
181 }