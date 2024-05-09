1 /*
2  * Custodial Smart Contract.  Copyright © 2017 by ABDK Consulting.
3  * Author: Mikhail Vladimirov <mikhail.vladimirov@gmail.com>
4  */
5 pragma solidity ^0.4.10;
6 
7 /**
8  * Custodial Smart Contract that that charges fee for keeping ether.
9  */
10 contract Custodial {
11   uint256 constant TWO_128 = 0x100000000000000000000000000000000; // 2^128
12   uint256 constant TWO_127 = 0x80000000000000000000000000000000; // 2^127
13 
14   /**
15    * Address of the client, i.e. owner of the ether kept by the contract.
16    */
17   address client;
18 
19   /**
20    * Address of the advisor, i.e. the one who receives fee charged by the
21    * contract for keeping client's ether.
22    */
23   address advisor;
24 
25   /**
26    * Capital, i.e. amount of client's ether (in Wei) kept by the contract.
27    */
28   uint256 capital;
29 
30   /**
31    * Time when capital was last updated (in seconds since epoch).
32    */
33   uint256 capitalTimestamp;
34 
35   /**
36    * Fee factor, the capital is multiplied by each second multiplied by 2^128.
37    * I.e. capital(t+1) = capital (t) * feeFactor / 2^128.
38    */
39   uint256 feeFactor;
40 
41   /**
42    * Create new Custodial contract with given client address, advisor address
43    * and fee factor.
44    *
45    * @param _client client address
46    * @param _advisor advisor address
47    * @param _feeFactor fee factor
48    */
49   function Custodial (address _client, address _advisor, uint256 _feeFactor) {
50     if (_feeFactor > TWO_128)
51       throw; // Fee factor must be less then or equal to 2^128
52 
53     client = _client;
54     advisor = _advisor;
55     feeFactor = _feeFactor;
56   }
57 
58   /**
59    * Get client's capital (in Wei).
60    *
61    * @param _currentTime current time in seconds since epoch
62    * @return client's capital
63    */
64   function getCapital (uint256 _currentTime)
65   constant returns (uint256 _result) {
66     _result = capital;
67     if (capital > 0 && capitalTimestamp < _currentTime && feeFactor < TWO_128) {
68       _result = mul (_result, pow (feeFactor, _currentTime - capitalTimestamp));
69     }
70   }
71 
72   /**
73    * Deposit ether on the client's account.
74    */
75   function deposit () payable {
76     if (msg.value > 0) {
77       updateCapital ();
78       if (msg.value >= TWO_128 - capital)
79         throw; // Capital should never exceed 2^128 Wei
80       capital += msg.value;
81       Deposit (msg.sender, msg.value);
82     }
83   }
84 
85   /**
86    * Withdraw ether from client's account and sent it to the client's address.
87    * May only be called by client.
88    *
89    * @param _value value to withdraw (in Wei)
90    * @return true if ether was successfully withdrawn, false otherwise
91    */
92   function withdraw (uint256 _value)
93   returns (bool _success) {
94     if (msg.sender != client) throw;
95 
96     if (_value > 0) {
97       updateCapital ();
98       if (_value <= capital) {
99         if (client.send (_value)) {
100           Withdrawal (_value);
101           capital -= _value;
102           return true;
103         } else return false;
104       } else return false;
105     } else return true;
106   }
107 
108   /**
109    * Withdraw all ether from client's account and sent it to the client's
110    * address.  May only be called by client.
111    *
112    * @return true if ether was successfully withdrawn, false otherwise
113    */
114   function withdrawAll ()
115   returns (bool _success) {
116     if (msg.sender != client) throw;
117 
118     updateCapital ();
119     if (capital > 0) {
120       if (client.send (capital)) {
121         Withdrawal (capital);
122         capital = 0;
123         return true;
124       } else return false;
125     } else return true;
126   }
127 
128   /**
129    * Withdraw fee charged by the contract as well as all unaccounted ether on
130    * contract's balance and send it to the advisor's address.  May only be
131    * called by advisor.
132    *
133    * @return true if fee and unaccounted ether was successfully withdrawn,
134    *          false otherwise
135    */
136   function withdrawFee ()
137   returns (bool _success) {
138     if (msg.sender != advisor) throw;
139 
140     uint256 _value = this.balance - getCapital (now);
141     if (_value > 0) {
142       return advisor.send (_value);
143     } else return true;
144   }
145 
146   /**
147    * Terminate account and send all its balance to advisor.  May only be called
148    * by advisor when capital is zero.
149    */
150   function terminate () {
151     if (msg.sender != advisor) throw;
152 
153     if (capital > 0) throw;
154     if (this.balance > 0) {
155       if (!advisor.send (this.balance)) {
156         // Ignore error
157       }
158     }
159     suicide (advisor);
160   }
161 
162   /**
163    * Update capital, i.e. charge fee from it.
164    */
165   function updateCapital ()
166   internal {
167     if (capital > 0 && capitalTimestamp < now && feeFactor < TWO_128) {
168       capital = mul (capital, pow (feeFactor, now - capitalTimestamp));
169     }
170     capitalTimestamp = now;
171   }
172 
173   /**
174    * Multiply _a by _b / 2^128.  Parameter _a should be less than or equal to
175    * 2^128 and parameter _b should be less than 2^128.
176    *
177    * @param _a left argument
178    * @param _b right argument
179    * @return _a * _b / 2^128
180    */
181   function mul (uint256 _a, uint256 _b)
182   internal constant returns (uint256 _result) {
183     if (_a > TWO_128) throw;
184     if (_b >= TWO_128) throw;
185     return (_a * _b + TWO_127) >> 128;
186   }
187 
188   /**
189    * Calculate (_a / 2^128)^_b * 2^128.  Parameter _a should be less than 2^128.
190    *
191    * @param _a left argument
192    * @param _b right argument
193    * @return (_a / 2^128)^_b * 2^128
194    */
195   function pow (uint256 _a, uint256 _b)
196   internal constant returns (uint256 _result) {
197     if (_a >= TWO_128) throw;
198 
199     _result = TWO_128;
200     while (_b > 0) {
201       if (_b & 1 == 0) {
202         _a = mul (_a, _a);
203         _b >>= 1;
204       } else {
205         _result = mul (_result, _a);
206         _b -= 1;
207       }
208     }
209   }
210 
211   /**
212    * Logged when ether was deposited on client's account.
213    *
214    * @param from address ether came from
215    * @param value amount of ether deposited (in Wei)
216    */
217   event Deposit (address indexed from, uint256 value);
218 
219   /**
220    * Logged when ether was withdrawn from client's account.
221    *
222    * @param value amount of ether withdrawn (in Wei)
223    */
224   event Withdrawal (uint256 value);
225 }