1 pragma solidity ^0.4.10;
2 
3 contract GasToken1 {
4     //////////////////////////////////////////////////////////////////////////
5     // Generic ERC20
6     //////////////////////////////////////////////////////////////////////////
7 
8     // owner -> amount
9     mapping(address => uint256) s_balances;
10     // owner -> spender -> max amount
11     mapping(address => mapping(address => uint256)) s_allowances;
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 
17     // Spec: Get the account balance of another account with address `owner`
18     function balanceOf(address owner) public constant returns (uint256 balance) {
19         return s_balances[owner];
20     }
21 
22     function internalTransfer(address from, address to, uint256 value) internal returns (bool success) {
23         if (value <= s_balances[from]) {
24             s_balances[from] -= value;
25             s_balances[to] += value;
26             Transfer(from, to, value);
27             return true;
28         } else {
29             return false;
30         }
31     }
32 
33     // Spec: Send `value` amount of tokens to address `to`
34     function transfer(address to, uint256 value) public returns (bool success) {
35         address from = msg.sender;
36         return internalTransfer(from, to, value);
37     }
38 
39     // Spec: Send `value` amount of tokens from address `from` to address `to`
40     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
41         address spender = msg.sender;
42         if(value <= s_allowances[from][spender] && internalTransfer(from, to, value)) {
43             s_allowances[from][spender] -= value;
44             return true;
45         } else {
46             return false;
47         }
48     }
49 
50     // Spec: Allow `spender` to withdraw from your account, multiple times, up
51     // to the `value` amount. If this function is called again it overwrites the
52     // current allowance with `value`.
53     function approve(address spender, uint256 value) public returns (bool success) {
54         address owner = msg.sender;
55         if (value != 0 && s_allowances[owner][spender] != 0) {
56             return false;
57         }
58         s_allowances[owner][spender] = value;
59         Approval(owner, spender, value);
60         return true;
61     }
62 
63     // Spec: Returns the `amount` which `spender` is still allowed to withdraw
64     // from `owner`.
65     // What if the allowance is higher than the balance of the `owner`?
66     // Callers should be careful to use min(allowance, balanceOf) to make sure
67     // that the allowance is actually present in the account!
68     function allowance(address owner, address spender) public constant returns (uint256 remaining) {
69         return s_allowances[owner][spender];
70     }
71 
72     //////////////////////////////////////////////////////////////////////////
73     // GasToken specifics
74     //////////////////////////////////////////////////////////////////////////
75 
76     uint8 constant public decimals = 2;
77     string constant public name = "Gastoken.io";
78     string constant public symbol = "GST1";
79 
80     // We start our storage at this location. The EVM word at this location
81     // contains the number of stored words. The stored words follow at
82     // locations (STORAGE_LOCATION_ARRAY+1), (STORAGE_LOCATION_ARRAY+2), ...
83     uint256 constant STORAGE_LOCATION_ARRAY = 0xDEADBEEF;
84 
85 
86     // totalSupply is the number of words we have in storage
87     function totalSupply() public constant returns (uint256 supply) {
88         uint256 storage_location_array = STORAGE_LOCATION_ARRAY;
89         assembly {
90             supply := sload(storage_location_array)
91         }
92     }
93 
94     // Mints `value` new sub-tokens (e.g. cents, pennies, ...) by filling up
95     // `value` words of EVM storage. The minted tokens are owned by the
96     // caller of this function.
97     function mint(uint256 value) public {
98         uint256 storage_location_array = STORAGE_LOCATION_ARRAY;  // can't use constants inside assembly
99 
100         if (value == 0) {
101             return;
102         }
103 
104         // Read supply
105         uint256 supply;
106         assembly {
107             supply := sload(storage_location_array)
108         }
109 
110         // Set memory locations in interval [l, r]
111         uint256 l = storage_location_array + supply + 1;
112         uint256 r = storage_location_array + supply + value;
113         assert(r >= l);
114 
115         for (uint256 i = l; i <= r; i++) {
116             assembly {
117                 sstore(i, 1)
118             }
119         }
120 
121         // Write updated supply & balance
122         assembly {
123             sstore(storage_location_array, add(supply, value))
124         }
125         s_balances[msg.sender] += value;
126     }
127 
128     function freeStorage(uint256 value) internal {
129         uint256 storage_location_array = STORAGE_LOCATION_ARRAY;  // can't use constants inside assembly
130 
131         // Read supply
132         uint256 supply;
133         assembly {
134             supply := sload(storage_location_array)
135         }
136 
137         // Clear memory locations in interval [l, r]
138         uint256 l = storage_location_array + supply - value + 1;
139         uint256 r = storage_location_array + supply;
140         for (uint256 i = l; i <= r; i++) {
141             assembly {
142                 sstore(i, 0)
143             }
144         }
145 
146         // Write updated supply
147         assembly {
148             sstore(storage_location_array, sub(supply, value))
149         }
150     }
151 
152     // Frees `value` sub-tokens (e.g. cents, pennies, ...) belonging to the
153     // caller of this function by clearing value words of EVM storage, which
154     // will trigger a partial gas refund.
155     function free(uint256 value) public returns (bool success) {
156         uint256 from_balance = s_balances[msg.sender];
157         if (value > from_balance) {
158             return false;
159         }
160 
161         freeStorage(value);
162 
163         s_balances[msg.sender] = from_balance - value;
164 
165         return true;
166     }
167 
168     // Frees up to `value` sub-tokens. Returns how many tokens were freed.
169     // Otherwise, identical to free.
170     function freeUpTo(uint256 value) public returns (uint256 freed) {
171         uint256 from_balance = s_balances[msg.sender];
172         if (value > from_balance) {
173             value = from_balance;
174         }
175 
176         freeStorage(value);
177 
178         s_balances[msg.sender] = from_balance - value;
179 
180         return value;
181     }
182 
183     // Frees `value` sub-tokens owned by address `from`. Requires that `msg.sender`
184     // has been approved by `from`.
185     function freeFrom(address from, uint256 value) public returns (bool success) {
186         address spender = msg.sender;
187         uint256 from_balance = s_balances[from];
188         if (value > from_balance) {
189             return false;
190         }
191 
192         mapping(address => uint256) from_allowances = s_allowances[from];
193         uint256 spender_allowance = from_allowances[spender];
194         if (value > spender_allowance) {
195             return false;
196         }
197 
198         freeStorage(value);
199 
200         s_balances[from] = from_balance - value;
201         from_allowances[spender] = spender_allowance - value;
202 
203         return true;
204     }
205 
206     // Frees up to `value` sub-tokens owned by address `from`. Returns how many tokens were freed.
207     // Otherwise, identical to `freeFrom`.
208     function freeFromUpTo(address from, uint256 value) public returns (uint256 freed) {
209         address spender = msg.sender;
210         uint256 from_balance = s_balances[from];
211         if (value > from_balance) {
212             value = from_balance;
213         }
214 
215         mapping(address => uint256) from_allowances = s_allowances[from];
216         uint256 spender_allowance = from_allowances[spender];
217         if (value > spender_allowance) {
218             value = spender_allowance;
219         }
220 
221         freeStorage(value);
222 
223         s_balances[from] = from_balance - value;
224         from_allowances[spender] = spender_allowance - value;
225 
226         return value;
227     }
228 }