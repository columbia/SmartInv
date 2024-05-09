1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract EZToken {
39     using SafeMath for uint256;
40 
41     // Public variables of the token
42     string public name = "EZToken" ;
43     string public symbol = "EZT";
44     uint8 public decimals = 8;
45     uint256 totalSupply_ = 0;
46     uint256 constant icoSupply = 11500000;
47     uint256 constant foundersSupply = 3500000;
48     uint256 constant yearlySupply = 3500000;
49     
50     
51     
52     mapping (address => uint) public freezedAccounts;
53 
54     
55     uint constant founderFronzenUntil = 1530403200;  //2018-07-01
56     uint constant year1FronzenUntil = 1546300800; //2019-01-01
57     uint constant year2FronzenUntil = 1577836800; //2020-01-01
58     uint constant year3FronzenUntil = 1609459200; //2021-01-01
59     uint constant year4FronzenUntil = 1640995200; //2022-01-01
60     uint constant year5FronzenUntil = 1672531200; //2023-01-01
61     uint constant year6FronzenUntil = 1704067200; //2024-01-01
62     uint constant year7FronzenUntil = 1735689600; //2025-01-01
63     uint constant year8FronzenUntil = 1767225600; //2026-01-01
64     uint constant year9FronzenUntil = 1798761600; //2027-01-01
65     uint constant year10FronzenUntil = 1830297600; //2028-01-01
66     
67     // This creates an array with all balances
68     mapping (address => uint256) internal balances;
69     mapping (address => mapping (address => uint256)) internal allowed;
70 
71 
72     // This generates a public event on the blockchain that will notify clients
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     // This notifies clients about the amount burnt
76     event Burn(address indexed from, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 
80     /**
81      * Constructor function
82      *
83      * Initializes contract with initial supply tokens to the creator of the contract
84      */
85     function EZToken(address _founderAddress, address _year1, address _year2, address _year3, address _year4, address _year5, address _year6, address _year7, address _year8, address _year9, address _year10 ) public {
86         totalSupply_ = 50000000 * 10 ** uint256(decimals);
87         
88         balances[msg.sender] = icoSupply * 10 ** uint256(decimals);                 
89         Transfer(address(0), msg.sender, icoSupply);
90         
91         _setFreezedBalance(_founderAddress, foundersSupply, founderFronzenUntil);
92 
93         _setFreezedBalance(_year1, yearlySupply, year1FronzenUntil);
94         _setFreezedBalance(_year2, yearlySupply, year2FronzenUntil);
95         _setFreezedBalance(_year3, yearlySupply, year3FronzenUntil);
96         _setFreezedBalance(_year4, yearlySupply, year4FronzenUntil);
97         _setFreezedBalance(_year5, yearlySupply, year5FronzenUntil);
98         _setFreezedBalance(_year6, yearlySupply, year6FronzenUntil);
99         _setFreezedBalance(_year7, yearlySupply, year7FronzenUntil);
100         _setFreezedBalance(_year8, yearlySupply, year8FronzenUntil);
101         _setFreezedBalance(_year9, yearlySupply, year9FronzenUntil);
102         _setFreezedBalance(_year10, yearlySupply, year10FronzenUntil);
103     }
104     
105     /**
106     * Total number of tokens in existence
107     */
108     function totalSupply() public view returns (uint256) {
109         return totalSupply_;
110     }
111 
112     /**
113      * Set balance and freeze time for address
114      */
115     function _setFreezedBalance(address _owner, uint256 _amount, uint _lockedUntil) internal {
116         require(_owner != address(0));
117         require(balances[_owner] == 0);
118         freezedAccounts[_owner] = _lockedUntil;
119         balances[_owner] = _amount * 10 ** uint256(decimals);     
120     }
121 
122     /**
123      * Get the token balance for account `_owner`
124      */
125     function balanceOf(address _owner) public constant returns (uint256 balance) {
126         return balances[_owner];
127     }
128     
129     /**
130      * Returns the amount of tokens approved by the owner that can be
131      * transferred to the spender's account
132      */
133     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
134         return allowed[_owner][_spender];
135     }
136 
137     /**
138      * Transfer token for a specified address
139      * @param _to The address to transfer to.
140      * @param _value The amount to be transferred.
141      */
142     function transfer(address _to, uint256 _value) public returns (bool) {
143         require(_to != address(0));
144         require(_value <= balances[msg.sender]);
145         require(freezedAccounts[msg.sender] == 0 || freezedAccounts[msg.sender] < now);
146         require(freezedAccounts[_to] == 0 || freezedAccounts[_to] < now);
147 
148         balances[msg.sender] = balances[msg.sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     /**
155      * Transfer tokens from one address to another
156      * @param _from address The address which you want to send tokens from
157      * @param _to address The address which you want to transfer to
158      * @param _value uint256 the amount of tokens to be transferred
159      */
160     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161         require(_to != address(0));
162         require(_value <= balances[_from]);
163         require(_value <= allowed[_from][msg.sender]);
164         require(freezedAccounts[_from] == 0 || freezedAccounts[_from] < now);
165         require(freezedAccounts[_to] == 0 || freezedAccounts[_to] < now);
166 
167         balances[_from] = balances[_from].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170         Transfer(_from, _to, _value);
171         return true;
172     }
173 
174     
175 
176     /**
177      * Set allowed for other address
178      *
179      * Allows `_spender` to spend no more than `_value` tokens on your behalf
180      *
181      * @param _spender The address authorized to spend
182      * @param _value the max amount they can spend
183      */
184     function approve(address _spender, uint256 _value) public returns (bool success) {
185         allowed[msg.sender][_spender] = _value;
186         Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190     /**
191      * Increase the amount of tokens that an owner allowed to a spender.
192      *
193      * approve should be called when allowed[_spender] == 0. To increment
194      * allowed value is better to use this function to avoid 2 calls (and wait until
195      * the first transaction is mined)
196      * From MonolithDAO Token.sol
197      * @param _spender The address which will spend the funds.
198      * @param _addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
201         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203         return true;
204     }
205 
206     /**
207      * Decrease the amount of tokens that an owner allowed to a spender.
208      *
209      * approve should be called when allowed[_spender] == 0. To decrement
210      * allowed value is better to use this function to avoid 2 calls (and wait until
211      * the first transaction is mined)
212      * From MonolithDAO Token.sol
213      * @param _spender The address which will spend the funds.
214      * @param _subtractedValue The amount of tokens to decrease the allowance by.
215      */
216     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
217         uint oldValue = allowed[msg.sender][_spender];
218         if (_subtractedValue > oldValue) {
219             allowed[msg.sender][_spender] = 0;
220         } else {
221             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222         }
223         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 
227 
228     /**
229     * Burns a specific amount of tokens.
230     * @param _value The amount of token to be burned.
231     */
232     function burn(uint256 _value) public {
233         require(_value <= balances[msg.sender]);
234         // no need to require value <= totalSupply, since that would imply the
235         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
236 
237         address burner = msg.sender;
238         balances[burner] = balances[burner].sub(_value);
239         totalSupply_ = totalSupply_.sub(_value);
240         Burn(burner, _value);
241     }
242 }