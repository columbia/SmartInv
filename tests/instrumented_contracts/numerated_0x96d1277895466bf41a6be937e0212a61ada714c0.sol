1 pragma solidity ^0.4.26;
2 
3 
4 
5 
6 contract SafeMath {
7     /**
8      * @dev Returns the addition of two unsigned integers, reverting on
9      * overflow.
10      *
11      * Counterpart to Solidity's `+` operator.
12      *
13      * Requirements:
14      *
15      * - Addition cannot overflow.
16      */
17     function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23 
24     /**
25      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
26      * overflow (when the result is negative).
27      *
28      * Counterpart to Solidity's `-` operator.
29      *
30      * Requirements:
31      *
32      * - Subtraction cannot overflow.
33      */
34     function safeSub(uint256 a, uint256 b) public pure returns (uint256) {
35         require(b <= a, "SafeMath: subtraction overflow");
36         uint256 c = a - b;
37 
38         return c;
39     }
40 
41 
42 }
43 
44 
45 contract TGBT is SafeMath {
46       
47     
48     
49     string public name;
50     string public symbol;
51     uint8 public decimals = 18;
52   
53     uint256 public totalSupply;
54 
55   
56     mapping (address => uint256) public balanceOf;
57     mapping (address => mapping (address => uint256)) public allowance;
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
61 
62 
63     constructor (uint256 initialSupply, string tokenName, string tokenSymbol) public {
64         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
65         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
66         name = tokenName;                                   // Set the name for display purposes
67         symbol = tokenSymbol;                               // Set the symbol for display purposes
68     }
69     
70     
71     /**
72      * _transfer Moves tokens `_value` from `_from` to `_to`.
73      *     
74      * 
75      * Emits a {Transfer} event.
76      *
77      * Requirements:
78      *
79      * - `_from` cannot be the zero address.
80      * - `_to` cannot be the zero address.
81      * - `_from` must have a balance of at least `_value`.
82      */
83     function _transfer(address _from, address _to, uint _value) internal {
84         require(_from != 0x0);
85         require(_to != 0x0);
86         require(balanceOf[_from] >= _value);
87         require(balanceOf[_to] + _value > balanceOf[_to]);
88        // no need  uint previousBalances = balanceOf[_from] + balanceOf[_to];
89         balanceOf[_from] = safeSub(balanceOf[_from],_value); // subtract from sender
90         balanceOf[_to] = safeAdd(balanceOf[_to],_value); // add the same to the reciptient
91         emit Transfer(_from, _to, _value);
92       // no need   assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
93     }
94     
95     
96     
97    /**
98      * _approve Sets `amount` as the allowance of `spender` over the `owner` s tokens.
99      *
100      *
101      * Emits an {Approval} event.
102      *
103      * Requirements:
104      *
105      * - `owner` cannot be the zero address.
106      * - `spender` cannot be the zero address.
107      */
108     function _approve(address owner, address spender, uint256 amount) internal  {
109         require(owner != 0x0);
110         require(spender != 0x0);
111 
112         allowance[owner][spender] = amount;
113         emit Approval(owner, spender, amount);
114     }
115     /**
116      *transfer
117      *
118      * Requirements:
119      *
120      * - `_to` cannot be the zero address.
121      * - the caller must have a balance of at least `_value`.
122      */
123     function transfer(address _to, uint256 _value) public returns (bool) {
124         _transfer(msg.sender, _to, _value);
125         return true;
126     }
127     
128     /**
129      * transferFrom
130      *
131      * Emits an {Approval} event indicating the updated allowance.
132      * 
133      * Requirements:
134      *
135      * - `_from` and `_to` cannot be the zero address.
136      * - `_from` must have a balance of at least `_value`.
137      * - the caller must have allowance for ``_from``'s tokens of at least
138      * `_value`.
139      */
140     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141         require(_value <= allowance[_from][msg.sender]);     // Check allowance
142         _approve(_from, msg.sender, safeSub(allowance[_from][msg.sender],_value));
143         _transfer(_from, _to, _value);
144         return true;
145     }
146     
147    /**
148      * approve
149      *
150      * Requirements:
151      *
152      * - `_spender` cannot be the zero address.
153      */
154     function approve(address _spender, uint256 _value) public
155         returns (bool success) {
156         _approve(msg.sender, _spender, _value);
157         return true;
158     }
159     
160    /**
161      * increaseAllowance
162      *
163      *
164      * Emits an {Approval} event indicating the updated allowance.
165      *
166      * Requirements:
167      *
168      * - `_spender` cannot be the zero address.
169      */
170      
171     function increaseAllowance(address _spender, uint256 addedValue) public  returns (bool) {
172         _approve(msg.sender, _spender, safeAdd(allowance[msg.sender][_spender],addedValue));
173         return true;
174     }
175 
176    /**
177      * decreaseAllowance
178      *
179      *
180      * Emits an {Approval} event indicating the updated allowance.
181      *
182      * Requirements:
183      *
184      * - `_spender` cannot be the zero address.
185      * - `spender` must have allowance for the caller of at least
186      * `subtractedValue`.
187      */
188     function decreaseAllowance(address _spender, uint256 subtractedValue) public  returns (bool) {
189         _approve(msg.sender, _spender, safeSub(allowance[msg.sender][_spender],subtractedValue));
190         return true;
191     }
192 
193    /**
194      * burn  
195      * Destroys `_value` tokens from the caller.
196      *
197      */
198     function burn(uint256 _value) public returns (bool) {
199         require(balanceOf[msg.sender] >= _value);                              // Check if the sender has enough
200         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender],_value);            // Subtract from the sender
201         totalSupply = safeSub(totalSupply,_value);                               // Updates totalSupply
202         emit  Transfer(msg.sender, address(0), _value);
203         return true;
204     }
205 
206    /**
207      * burnFrom
208      * Destroys `_value` tokens from `_from`, deducting from the caller's
209      * allowance.
210      *
211      *
212      * Requirements:
213      *
214      * - the caller must have allowance for ``_from``'s tokens of at least
215      * `_value`.
216      */
217     function burnFrom(address _from, uint256 _value) public returns (bool) {
218         require(_value <= allowance[_from][msg.sender]);                         // Check allowance
219         require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
220         
221         uint256 decreasedAllowance = safeSub(allowance[_from][msg.sender],_value);
222         _approve(_from, msg.sender,decreasedAllowance);
223         balanceOf[_from] = safeSub(balanceOf[_from],_value);                         // Subtract from the targeted balance
224         totalSupply = safeSub(totalSupply,_value) ;                                  // Update totalSupply
225         emit Transfer(_from, address(0), _value);
226         return true;
227     }
228 }