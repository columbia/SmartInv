1 contract Token {
2 
3     function totalSupply() constant returns (uint256 supply) {}
4 
5     function balanceOf(address _owner) constant returns (uint256 balance) {}
6 
7     function transfer(address _to, uint256 _value) returns (bool success) {}
8 
9     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
10 
11     function approve(address _spender, uint256 _value) returns (bool success) {}
12 
13     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 contract SafeMath{
20   function safeMul(uint a, uint b) internal returns (uint) {
21     uint c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function safeDiv(uint a, uint b) internal returns (uint) {
27     assert(b > 0);
28     uint c = a / b;
29     assert(a == b * c + a % b);
30     return c;
31   }
32 	
33 	function safeSub(uint a, uint b) internal returns (uint) {
34     	assert(b <= a);
35     	return a - b;
36   }
37 
38 	function safeAdd(uint a, uint b) internal returns (uint) {
39     	uint c = a + b;
40     	assert(c >= a);
41     	return c;
42   }
43 	function assert(bool assertion) internal {
44 	    if (!assertion) {
45 	      revert();
46 	    }
47 	}
48 }
49 
50 
51 contract StandardToken is Token , SafeMath{
52 
53     function transfer(address _to, uint256 _value) returns (bool success) {
54         if (balances[msg.sender] >= _value && _value > 0) {
55             balances[msg.sender] = safeSub(balances[msg.sender], _value);
56             balances[_to] = safeAdd(balances[_to],_value);
57             Transfer(msg.sender, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63          if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
64             balances[_to] = safeAdd(balances[_to],_value);
65             balances[_from] = safeSub(balances[_from],_value);
66             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
67             Transfer(_from, _to, _value);
68             return true;
69         } else { return false; }
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83       return allowed[_owner][_spender];
84     }
85 
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88     uint256 public totalSupply;
89 }
90 
91 contract Ownable {
92   address public owner = msg.sender;
93 
94   /// @notice check if the caller is the owner of the contract
95   modifier onlyOwner {
96     if (msg.sender != owner) throw;
97     _;
98   }
99 
100   /// @notice change the owner of the contract
101   /// @param _newOwner the address of the new owner of the contract.
102   function changeOwner(address _newOwner)
103   onlyOwner
104   {
105     if(_newOwner == 0x0) throw;
106     owner = _newOwner;
107   }
108 }
109 contract StrHelper{
110   function uintToString(uint256 v) constant returns (string str) {
111         uint maxlength = 100;
112         bytes memory reversed = new bytes(maxlength);
113         uint i = 0;
114         while (v != 0) {
115             uint remainder = v % 10;
116             v = v / 10;
117             reversed[i++] = byte(48 + remainder);
118         }
119         bytes memory s = new bytes(i);
120         for (uint j = 0; j < i; j++) {
121             s[j] = reversed[i - 1 - j];
122         }
123         str = string(s);
124     }
125 
126     function appendUintToString(string inStr, uint256 v) constant returns (string str) {
127         uint maxlength = 78;
128         bytes memory reversed = new bytes(maxlength);
129         uint i = 0;
130         while (v != 0) {
131             uint remainder = v % 10;
132             v = v / 10;
133             reversed[i++] = byte(48 + remainder);
134         }
135         bytes memory inStrb = bytes(inStr);
136         bytes memory s = new bytes(inStrb.length + i);
137         uint j;
138         for (j = 0; j < inStrb.length; j++) {
139             s[j] = inStrb[j];
140         }
141         for (j = 0; j < i; j++) {
142             s[j + inStrb.length] = reversed[i - 1 - j];
143         }
144         str = string(s);
145     }
146 }
147 
148 contract Ex is StandardToken, Ownable, StrHelper {
149     
150     
151   event Mint(address indexed to, uint256 amount);
152   event Minty(string announcement);
153   
154     string public name = "Ex Token";   
155     string public description = "Mining reward for running an Ex Node";
156     string public additionalInfo = "The value of Ex token is set at £1000. The lowest denomination of the Ex token is 0.01 (£10); anything below this should be paid in smiles, good wishes and agreeable nods. VAT applicable on all transactions.";
157     string public moreInfo = "As of Oct 2018, the Ex Network has sold 20% of it's equity @ £10k per share to fend for the startup costs. Thus evaluating the Coy @ £1M at the time of idea floating.";
158     string public evenMoreInfo = "£1M worth of Ex tokens to be split 80-20% between the two parties holding equity at genesis time. Initial Supply =  1000 🖤";
159     uint8 public decimals = 2;
160     string public symbol = "🖤";
161   
162 ///////////////////
163 ///////////////////  
164 function () {
165         throw;
166     }
167 ///////////////////
168 ///////////////////
169 function Ex() {
170    
171    /*
172    Description: As of Oct 2018, the Ex Network has sold 20% of it's equity @ £10k per share to fend for the startup costs. Thus evaluating the Coy @ £1M at the time of idea floating.
173    Distribution: £1M worth of Ex tokens to be split 80-20% between the two parties represented below.
174    Initial supply: 1000 🖤
175    */
176 
177         mint(0x07777ae0a01ca3db33fc0128f7cc9fdbb783118c,20000);
178         mint(0x07777c1ab6d8ee46c3b616819bdf7900373fc530,80000);
179     }
180 ///////////////////
181 ///////////////////  
182 function mint(
183     address _to,
184     uint256 _amount
185   )
186     public
187     onlyOwner
188     returns (bool)
189   {
190     totalSupply = safeAdd(totalSupply,_amount);
191     balances[_to] = safeAdd(balances[_to],_amount);
192     Mint(_to, _amount);
193     Transfer(address(0), _to, _amount);
194     Minty(appendUintToString("Ex tokens generated in this round: ",_amount));
195     return true;
196   }
197 ///////////////////
198 ///////////////////
199 function mintMulti(
200     address[] _to,
201     uint256[] _amount
202   )
203     public
204     onlyOwner
205     returns (bool)
206   {
207       if(_to.length != _amount.length)
208       return(false);
209       
210       uint256 i = 0;
211       uint256 total=0;
212         while (i < _to.length) {
213             totalSupply = safeAdd(totalSupply,_amount[i]);
214             balances[_to[i]] = safeAdd(balances[_to[i]],_amount[i]);
215             Mint(_to[i], _amount[i]);
216             Transfer(address(0), _to[i], _amount[i]);
217             total=safeAdd(total,_amount[i]);
218            i += 1;
219         }
220     
221       Minty(appendUintToString("Ex tokens generated in this round: ",total));
222       return true;
223   }
224   
225 
226 }