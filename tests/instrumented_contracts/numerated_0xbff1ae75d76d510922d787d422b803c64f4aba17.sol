1 pragma solidity 0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10 
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a * b;
25         assert(a == 0 || c / a == b);
26 
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33 
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40 
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47 
48         return c;
49     }
50 }
51 
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58     using SafeMath for uint256;
59 
60     mapping(address => uint256) balances;
61 
62     /**
63      * @dev transfer token for a specified address
64      * @param _to The address to transfer to.
65      * @param _value The amount to be transferred.
66      */
67     function transfer(address _to, uint256 _value) public returns (bool) {
68         require(_to != address(0));
69         require(_value <= balances[msg.sender]);
70 
71         // SafeMath.sub will throw if there is not enough balance.
72         balances[msg.sender] = balances[msg.sender].sub(_value);
73         balances[_to] = balances[_to].add(_value);
74 
75         Transfer(msg.sender, _to, _value);
76 
77         return true;
78     }
79 
80 
81     /**
82      * @dev Gets the balance of the specified address.
83      * @param _owner The address to query the the balance of.
84      * @return An uint256 representing the amount owned by the passed address.
85      */
86     function balanceOf(address _owner) public view returns (uint256 balance) {
87         return balances[_owner];
88     }
89 }
90 
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20 is ERC20Basic {
97     function allowance(address owner, address spender) public view returns (uint256);
98     function transferFrom(address from, address to, uint256 value) public returns (bool);
99     function approve(address spender, uint256 value) public returns (bool);
100 
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * @dev https://github.com/ethereum/EIPs/issues/20
110  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20, BasicToken {
113     mapping(address => mapping (address => uint256)) internal allowed;
114 
115     /**
116     * @dev Transfer tokens from one address to another
117     * @param _from address The address which you want to send tokens from
118     * @param _to address The address which you want to transfer to
119     * @param _value uint256 the amount of tokens to be transferred
120     */
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122         require(_to != address(0));
123         require(_value <= balances[_from]);
124         require(_value <= allowed[_from][msg.sender]);
125 
126         balances[_from] = balances[_from].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129 
130         Transfer(_from, _to, _value);
131 
132         return true;
133     }
134 
135 
136     /**
137      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138      *
139      * Beware that changing an allowance with this method brings the risk that someone may use both the old
140      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      * @param _spender The address which will spend the funds.
144      * @param _value The amount of tokens to be spent.
145      */
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149 
150         return true;
151     }
152 
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param _owner address The address which owns the funds.
157      * @param _spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(address _owner, address _spender) public view returns (uint256) {
161         return allowed[_owner][_spender];
162     }
163 
164 
165     /**
166      * @dev Increase the amount of tokens that an owner allowed to a spender.
167      *
168      * approve should be called when allowed[_spender] == 0. To increment
169      * allowed value is better to use this function to avoid 2 calls (and wait until
170      * the first transaction is mined)
171      * From MonolithDAO Token.sol
172      * @param _spender The address which will spend the funds.
173      * @param _addedValue The amount of tokens to increase the allowance by.
174      */
175     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
176         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
177         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178 
179         return true;
180     }
181 
182 
183     /**
184      * @dev Decrease the amount of tokens that an owner allowed to a spender.
185      *
186      * approve should be called when allowed[_spender] == 0. To decrement
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * @param _spender The address which will spend the funds.
191      * @param _subtractedValue The amount of tokens to decrease the allowance by.
192      */
193     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
194         uint oldValue = allowed[msg.sender][_spender];
195 
196         if (_subtractedValue > oldValue) {
197             allowed[msg.sender][_spender] = 0;
198         } else {
199             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200         }
201 
202         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203 
204         return true;
205     }
206 }
207 
208 
209 contract KRWT_Token is StandardToken {
210     string constant public name = "KRWT (Test Drive - 20180402)";
211     string constant public symbol = "KRWT";
212     uint8 constant public decimals = 0;
213     uint public totalSupply = 10000000000000 * 10**18;
214 
215     function KRWT_Token() public {
216         balances[msg.sender] = totalSupply;
217     }
218 }