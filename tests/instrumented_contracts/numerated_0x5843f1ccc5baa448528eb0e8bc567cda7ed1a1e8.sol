1 pragma solidity ^0.5.2;
2 
3 contract IDFEngine {
4     function disableOwnership() public;
5     function transferOwnership(address newOwner_) public;
6     function acceptOwnership() public;
7     function setAuthority(address authority_) public;
8     function deposit(address _sender, address _tokenID, uint _feeTokenIdx, uint _amount) public returns (uint);
9     function withdraw(address _sender, address _tokenID, uint _feeTokenIdx, uint _amount) public returns (uint);
10     function destroy(address _sender, uint _feeTokenIdx, uint _amount) public returns (bool);
11     function claim(address _sender, uint _feeTokenIdx) public returns (uint);
12     function oneClickMinting(address _sender, uint _feeTokenIdx, uint _amount) public;
13 }
14 
15 contract DSAuthority {
16     function canCall(
17         address src, address dst, bytes4 sig
18     ) public view returns (bool);
19 }
20 
21 contract DSAuthEvents {
22     event LogSetAuthority (address indexed authority);
23     event LogSetOwner     (address indexed owner);
24     event OwnerUpdate     (address indexed owner, address indexed newOwner);
25 }
26 
27 contract DSAuth is DSAuthEvents {
28     DSAuthority  public  authority;
29     address      public  owner;
30     address      public  newOwner;
31 
32     constructor() public {
33         owner = msg.sender;
34         emit LogSetOwner(msg.sender);
35     }
36 
37     // Warning: you should absolutely sure you want to give up authority!!!
38     function disableOwnership() public onlyOwner {
39         owner = address(0);
40         emit OwnerUpdate(msg.sender, owner);
41     }
42 
43     function transferOwnership(address newOwner_) public onlyOwner {
44         require(newOwner_ != owner, "TransferOwnership: the same owner.");
45         newOwner = newOwner_;
46     }
47 
48     function acceptOwnership() public {
49         require(msg.sender == newOwner, "AcceptOwnership: only new owner do this.");
50         emit OwnerUpdate(owner, newOwner);
51         owner = newOwner;
52         newOwner = address(0x0);
53     }
54 
55     ///[snow] guard is Authority who inherit DSAuth.
56     function setAuthority(DSAuthority authority_)
57         public
58         onlyOwner
59     {
60         authority = authority_;
61         emit LogSetAuthority(address(authority));
62     }
63 
64     modifier onlyOwner {
65         require(isOwner(msg.sender), "ds-auth-non-owner");
66         _;
67     }
68 
69     function isOwner(address src) internal view returns (bool) {
70         return bool(src == owner);
71     }
72 
73     modifier auth {
74         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
75         _;
76     }
77 
78     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
79         if (src == address(this)) {
80             return true;
81         } else if (src == owner) {
82             return true;
83         } else if (authority == DSAuthority(0)) {
84             return false;
85         } else {
86             return authority.canCall(src, address(this), sig);
87         }
88     }
89 }
90 
91 contract DFUpgrader is DSAuth {
92 
93     // MEMBERS
94     // @dev  The reference to the active converter implementation.
95     IDFEngine public iDFEngine;
96 
97     /// @dev  The map of lock ids to pending implementation changes.
98     address newDFEngine;
99 
100     // CONSTRUCTOR
101     constructor () public {
102         iDFEngine = IDFEngine(0x0);
103     }
104 
105     // PUBLIC FUNCTIONS
106     // (UPGRADE)
107     /** @notice  Requests a change of the active implementation associated
108       * with this contract.
109       *
110       * @dev  Anyone can call this function, but confirming the request is authorized
111       * by the custodian.
112       *
113       * @param  _newDFEngine  The address of the new active implementation.
114       */
115     function requestImplChange(address _newDFEngine) public onlyOwner {
116         require(_newDFEngine != address(0), "_newDFEngine: The address is empty");
117 
118         newDFEngine = _newDFEngine;
119 
120         emit ImplChangeRequested(msg.sender, _newDFEngine);
121     }
122 
123     /** @notice  Confirms a pending change of the active implementation
124       * associated with this contract.
125       *
126       * @dev  the `Converter ConverterImpl` member will be updated
127       * with the requested address.
128       *
129       */
130     function confirmImplChange() public onlyOwner {
131         iDFEngine = IDFEngine(newDFEngine);
132 
133         emit ImplChangeConfirmed(address(iDFEngine));
134     }
135 
136     /// @dev  Emitted by successful `requestImplChange` calls.
137     event ImplChangeRequested(address indexed _msgSender, address indexed _proposedImpl);
138 
139     /// @dev Emitted by successful `confirmImplChange` calls.
140     event ImplChangeConfirmed(address indexed _newImpl);
141 }
142 
143 contract DFProtocol is DFUpgrader {
144     /******************************************/
145     /* Public events that will notify clients */
146     /******************************************/
147 
148     /**
149      * @dev Emmit when `_tokenAmount` tokens of `_tokenID` deposits from one account(`_sender`),
150      * and show the amout(`_usdxAmount`) tokens generate.
151      */
152     event Deposit (address indexed _tokenID, address indexed _sender, uint _tokenAmount, uint _usdxAmount);
153 
154     /**
155      * @dev Emmit when `_expectedAmount` tokens of `_tokenID` withdraws from one account(`_sender`),
156      * and show the amount(`_actualAmount`) tokens have been withdrawed successfully.
157      *
158      * Note that `_actualAmount` may be less than or equal to `_expectedAmount`.
159      */
160     event Withdraw(address indexed _tokenID, address indexed _sender, uint _expectedAmount, uint _actualAmount);
161 
162     /**
163      * @dev Emmit when `_amount` USDx were destroied from one account(`_sender`).
164      */
165     event Destroy (address indexed _sender, uint _usdxAmount);
166 
167     /**
168      * @dev Emmit when `_usdxAmount` USDx were claimed from one account(`_sender`).
169      */
170     event Claim(address indexed _sender, uint _usdxAmount);
171 
172     /**
173      * @dev Emmit when `_amount` USDx were minted from one account(`_sender`).
174      */
175     event OneClickMinting(address indexed _sender, uint _usdxAmount);
176 
177     /******************************************/
178     /*            User interfaces             */
179     /******************************************/
180 
181     /**
182      * @dev The caller deposits `_tokenAmount` tokens of `_tokenID`,
183      * and the caller would like to use `_feeTokenIdx` as the transaction fee.
184      *
185      * Note that: 1)For `_tokenID`: it should be one of the supported stabel currencies.
186      *            2)For `_feeTokenIdx`: 0 is DF, and 1 is USDx.
187      *
188      * Returns a uint value indicating the total amount that generating USDx.
189      *
190      * Emits a `Deposit` event.
191      */
192     function deposit(address _tokenID, uint _feeTokenIdx, uint _tokenAmount) public returns (uint){
193         uint _usdxAmount = iDFEngine.deposit(msg.sender, _tokenID, _feeTokenIdx, _tokenAmount);
194         emit Deposit(_tokenID, msg.sender, _tokenAmount, _usdxAmount);
195         return _usdxAmount;
196     }
197 
198     /**
199      * @dev The caller withdraws `_expectedAmount` tokens of `_tokenID`,
200      * and the caller would like to use `_feeTokenIdx` as the transaction fee.
201      *
202      * Returns a uint value indicating the total amount of the caller has withdrawed successfully.
203      *
204      * Emits a `Withdraw` event.
205      */
206     function withdraw(address _tokenID, uint _feeTokenIdx, uint _expectedAmount) public returns (uint) {
207         uint _actualAmount = iDFEngine.withdraw(msg.sender, _tokenID, _feeTokenIdx, _expectedAmount);
208         emit Withdraw(_tokenID, msg.sender, _expectedAmount, _actualAmount);
209         return _actualAmount;
210     }
211 
212     /**
213      * @dev The caller destroies `_usdxAmount` USDx,
214      * and the caller would like to use `_feeTokenIdx` as the transaction fee.
215      *
216      * Emits a `Destroy` event.
217      */
218     function destroy(uint _feeTokenIdx, uint _usdxAmount) public {
219         iDFEngine.destroy(msg.sender, _feeTokenIdx, _usdxAmount);
220         emit Destroy(msg.sender, _usdxAmount);
221     }
222 
223     /**
224      * @dev The caller claims to get spare USDx he can get,
225      * and the caller would like to use `_feeTokenIdx` as the transaction fee.
226      *
227      * Returns a uint value indicating the total amount of the caller has claimed.
228      *
229      * Emits a `Claim` event.
230      */
231     function claim(uint _feeTokenIdx) public returns (uint) {
232         uint _usdxAmount = iDFEngine.claim(msg.sender, _feeTokenIdx);
233         emit Claim(msg.sender, _usdxAmount);
234         return _usdxAmount;
235     }
236 
237     /**
238      * @dev The caller mints `_usdxAmount` USDx directly,
239      * and the caller would like to use `_feeTokenIdx` as the transaction fee.
240      *
241      * Emits a `OneClickMinting` event.
242      */
243     function oneClickMinting(uint _feeTokenIdx, uint _usdxAmount) public {
244         iDFEngine.oneClickMinting(msg.sender, _feeTokenIdx, _usdxAmount);
245         emit OneClickMinting(msg.sender, _usdxAmount);
246     }
247 }