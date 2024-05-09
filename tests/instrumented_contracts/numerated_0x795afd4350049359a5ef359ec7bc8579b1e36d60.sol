1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name = "SurveyToken";
8     string public symbol = "SRT";
9     uint8 public decimals = 18;
10     uint256 public totalSupply;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     // This notifies clients about the amount burnt
20     event Burn(address indexed from, uint256 value);
21 
22     /**
23      * Constrctor function
24      *
25      * Initializes contract with initial supply tokens to the creator of the contract
26      */
27     function TokenERC20(uint256 initialSupply) public {
28         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
29         balanceOf[msg.sender] = totalSupply;
30     }
31 
32     /**
33      * Internal transfer, only can be called by this contract
34      */
35     function _transfer(address _from, address _to, uint _value) internal {
36         // Prevent transfer to 0x0 address. Use burn() instead
37         require(_to != 0x0);
38         // Check if the sender has enough
39         require(balanceOf[_from] >= _value);
40         // Check for overflows
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42         // Save this for an assertion in the future
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         // Subtract from the sender
45         balanceOf[_from] -= _value;
46         // Add the same to the recipient
47         balanceOf[_to] += _value;
48         Transfer(_from, _to, _value);
49         // Asserts are used to use static analysis to find bugs in your code. They should never fail
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     /**
54      * Transfer tokens
55      *
56      * Send `_value` tokens to `_to` from your account
57      *
58      * @param _to The address of the recipient
59      * @param _value the amount to send
60      */
61     function transfer(address _to, uint256 _value) public {
62         _transfer(msg.sender, _to, _value);
63     }
64 
65     /**
66      * Transfer tokens from other address
67      *
68      * Send `_value` tokens to `_to` in behalf of `_from`
69      *
70      * @param _from The address of the sender
71      * @param _to The address of the recipient
72      * @param _value the amount to send
73      */
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         require(_value <= allowance[_from][msg.sender]);     // Check allowance
76         allowance[_from][msg.sender] -= _value;
77         _transfer(_from, _to, _value);
78         return true;
79     }
80 
81     /**
82      * Set allowance for other address
83      *
84      * Allows `_spender` to spend no more than `_value` tokens in your behalf
85      *
86      * @param _spender The address authorized to spend
87      * @param _value the max amount they can spend
88      */
89     function approve(address _spender, uint256 _value) public
90         returns (bool success) {
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address and notify
97      *
98      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      * @param _extraData some extra information to send to the approved contract
103      */
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
105         public
106         returns (bool success) {
107         tokenRecipient spender = tokenRecipient(_spender);
108         if (approve(_spender, _value)) {
109             spender.receiveApproval(msg.sender, _value, this, _extraData);
110             return true;
111         }
112     }
113 
114     /**
115      * Destroy tokens
116      *
117      * Remove `_value` tokens from the system irreversibly
118      *
119      * @param _value the amount of money to burn
120      */
121     function burn(uint256 _value) public returns (bool success) {
122         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
123         balanceOf[msg.sender] -= _value;            // Subtract from the sender
124         totalSupply -= _value;                      // Updates totalSupply
125         Burn(msg.sender, _value);
126         return true;
127     }
128 
129     /**
130      * Destroy tokens from other account
131      *
132      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
133      *
134      * @param _from the address of the sender
135      * @param _value the amount of money to burn
136      */
137     function burnFrom(address _from, uint256 _value) public returns (bool success) {
138         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
139         require(_value <= allowance[_from][msg.sender]);    // Check allowance
140         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
141         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
142         totalSupply -= _value;                              // Update totalSupply
143         Burn(_from, _value);
144         return true;
145     }
146 }
147 
148 contract owned {
149     address public owner;
150 
151     function owned() public {
152         owner = msg.sender;
153     }
154 
155     modifier onlyOwner {
156         require(msg.sender == owner);
157         _;
158     }
159 
160     function transferOwnership(address newOwner) public onlyOwner {
161         owner = newOwner;
162     }
163 }
164 
165 contract SurveyToken is TokenERC20, owned
166 {
167     struct Survey {
168         address initiator;
169         uint256 toPay;
170         uint256 balance;
171         uint32 tickets;
172         uint256 reward;
173         mapping(address => bool) respondents;
174     }
175 
176     address feeReceiver;
177 
178     mapping(bytes32 => Survey) surveys;
179     mapping(address => bool) robots;
180 
181     modifier onlyRobot {
182         require(robots[msg.sender]);
183         _;
184     }
185 
186     function SurveyToken(uint256 initialSupply) public
187     TokenERC20(initialSupply) {
188         feeReceiver = msg.sender;
189     }
190 
191     function setFeeReceiver(address newReceiver) public onlyOwner {
192         require(newReceiver != 0x0);
193         feeReceiver = newReceiver;
194     }
195 
196     function addRobot(address newRobot) public onlyOwner returns(bool success) {
197         require(newRobot != 0x0);
198         require(robots[newRobot] == false);
199 
200         robots[newRobot] = true;
201         return true;
202     }
203     function removeRobot(address oldRobot) public onlyOwner returns(bool success) {
204         require(oldRobot != 0x0);
205         require(robots[oldRobot] == true);
206 
207         robots[oldRobot] = false;
208         return true;
209     }
210 
211     function placeNewSurvey(bytes32 key, uint256 toPay, uint32 tickets, uint256 reward) public returns(bool success) {
212         require(surveys[key].initiator == 0x0);
213         require(tickets > 0 && reward >= 0);
214         uint256 rewardBalance = tickets * reward;
215         require(rewardBalance < toPay && toPay > 0);
216         require(balanceOf[msg.sender] >= toPay);
217         
218         uint256 fee = toPay - rewardBalance;
219         require(balanceOf[feeReceiver] + fee > balanceOf[feeReceiver]);
220         transfer(feeReceiver, fee);
221         
222         balanceOf[msg.sender] -= rewardBalance;
223         surveys[key] = Survey(msg.sender, toPay, rewardBalance, tickets, reward);
224         Transfer(msg.sender, 0x0, rewardBalance);
225         return true;
226     }
227 
228     function giveReward(bytes32 surveyKey, address respondent, uint8 karma) public onlyRobot returns(bool success) {
229         require(respondent != 0x0);
230         Survey storage surv = surveys[surveyKey];
231         require(surv.respondents[respondent] == false);
232         require(surv.tickets > 0 && surv.reward > 0 && surv.balance >= surv.reward);
233         require(karma >= 0 && karma <= 10);
234         
235         if (karma < 10) {
236             uint256 fhalf = surv.reward / 2;
237             uint256 shalf = ((surv.reward - fhalf) / 10) * karma;
238             uint256 respReward = fhalf + shalf;
239             uint256 fine = surv.reward - respReward;
240             
241             require(balanceOf[respondent] + respReward > balanceOf[respondent]);
242             require(balanceOf[feeReceiver] + fine > balanceOf[feeReceiver]);
243             
244             balanceOf[respondent] += respReward;
245             Transfer(0x0, respondent, respReward);
246             
247             balanceOf[feeReceiver] += fine;
248             Transfer(0x0, feeReceiver, fine);
249         } else {
250             require(balanceOf[respondent] + surv.reward > balanceOf[respondent]);
251             balanceOf[respondent] += surv.reward;
252             Transfer(0x0, respondent, surv.reward);
253         }
254 
255         surv.tickets--;
256         surv.balance -= surv.reward;
257         surv.respondents[respondent] = true;
258         return true;
259     }
260     
261     function removeSurvey(bytes32 surveyKey) public onlyRobot returns(bool success) {
262         Survey storage surv = surveys[surveyKey];
263         require(surv.initiator != 0x0 && surv.balance > 0);
264         require(balanceOf[surv.initiator] + surv.balance > balanceOf[surv.initiator]);
265         
266         balanceOf[surv.initiator] += surv.balance;
267         Transfer(0x0, surv.initiator, surv.balance);
268         surv.balance = 0;
269         return true;
270     }
271 
272     function getSurveyInfo(bytes32 key) public constant returns(bool success, uint256 toPay, uint32 tickets, uint256 reward) {
273         Survey storage surv = surveys[key];
274         require(surv.initiator != 0x0);
275 
276         return (true, surv.toPay, surv.tickets, surv.reward);
277     }
278 }