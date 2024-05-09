1 pragma solidity 0.4.24;
2 pragma experimental "v0.5.0";
3 
4 interface RTCoinInterface {
5     
6 
7     /** Functions - ERC20 */
8     function transfer(address _recipient, uint256 _amount) external returns (bool);
9 
10     function transferFrom(address _owner, address _recipient, uint256 _amount) external returns (bool);
11 
12     function approve(address _spender, uint256 _amount) external returns (bool approved);
13 
14     /** Getters - ERC20 */
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address _holder) external view returns (uint256);
18 
19     function allowance(address _owner, address _spender) external view returns (uint256);
20 
21     /** Getters - Custom */
22     function mint(address _recipient, uint256 _amount) external returns (bool);
23 
24     function stakeContractAddress() external view returns (address);
25 
26     function mergedMinerValidatorAddress() external view returns (address);
27     
28     /** Functions - Custom */
29     function freezeTransfers() external returns (bool);
30 
31     function thawTransfers() external returns (bool);
32 }
33 
34 library SafeMath {
35 
36   // We use `pure` bbecause it promises that the value for the function depends ONLY
37   // on the function arguments
38     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
39         uint256 c = a * b;
40         require(a == 0 || c / a == b);
41         return c;
42     }
43 
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a / b;
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b <= a);
51         return a - b;
52     }
53 
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57         return c;
58     }
59 }
60 
61 /// @title TEMPORAL Payment Contract
62 /// @author Postables, RTrade Technologies Ltd
63 /// @dev We able V5 for safety features, see https://solidity.readthedocs.io/en/v0.4.24/security-considerations.html#take-warnings-seriously
64 contract Payments {
65     using SafeMath for uint256;    
66 
67     // we mark as constant private to save gas
68     bytes constant private PREFIX = "\x19Ethereum Signed Message:\n32";
69     // these addresses will need to be changed before deployment, and validated after deployment
70     // we hardcode them for security reasons to avoid any possible risk of compromised accounts being able to change anything on this contract.
71     // in the event that one of the addresses is compromised, the contract will be self destructed
72     address constant private SIGNER = 0xa80cD01dD37c29116549AA879c44C824b703828A;
73     address constant private TOKENADDRESS = 0xecc043b92834c1ebDE65F2181B59597a6588D616;
74     address constant private HOTWALLET = 0x3eC6481365c2c2b37d7b939B5854BFB7e5e83C10;
75     RTCoinInterface constant private RTI = RTCoinInterface(TOKENADDRESS);
76     string constant public VERSION = "production";
77 
78     address public admin;
79 
80     // PaymentState will keep track of the state of a payment, nil means we havent seen th payment before
81     enum PaymentState{ nil, paid }
82     // How payments can be made, RTC or eth
83     enum PaymentMethod{ RTC, ETH }
84 
85     struct PaymentStruct {
86         uint256 paymentNumber;
87         uint256 chargeAmountInWei;
88         PaymentMethod method;
89         PaymentState state;
90     }
91 
92     mapping (address => uint256) public numPayments;
93     mapping (address => mapping(uint256 => PaymentStruct)) public payments;
94 
95     event PaymentMade(address _payer, uint256 _paymentNumber, uint8 _paymentMethod, uint256 _paymentAmount);
96 
97     modifier validPayment(uint256 _paymentNumber) {
98         require(payments[msg.sender][_paymentNumber].state == PaymentState.nil, "payment already made");
99         _;
100     }
101 
102     modifier onlyAdmin() {
103         require(msg.sender == admin, "sender must be admin");
104         _;
105     }
106 
107     constructor() public {
108         admin = msg.sender;
109     }
110 
111     /** @notice Used to submit a payment for TEMPORAL uploads
112         * @dev Can use ERC191 or non ERC191 signed messages
113         * @param _h This is the message hash that has been signed
114         * @param _v This is pulled from the signature
115         * @param _r This is pulled from the signature
116         * @param _s This is pulled from the signature
117         * @param _paymentNumber This is the current payments number (how many payments the user has submitted)
118         * @param _paymentMethod This is the payment method (RTC, ETH) being used
119         * @param _chargeAmountInWei This is how much the user is to be charged
120         * @param _prefixed This indicates whether or not the signature was generated using ERC191 standards
121      */
122     function makePayment(
123         bytes32 _h,
124         uint8   _v,
125         bytes32 _r,
126         bytes32 _s,
127         uint256 _paymentNumber,
128         uint8   _paymentMethod,
129         uint256 _chargeAmountInWei,
130         bool   _prefixed) // this allows us to sign messages on our own, without prefix https://github.com/ethereum/EIPs/issues/191
131         public
132         payable
133         validPayment(_paymentNumber)
134         returns (bool)
135     {
136         require(_paymentMethod == 0 || _paymentMethod == 1, "invalid payment method");
137         bytes32 image;
138         if (_prefixed) {
139             bytes32 preimage = generatePreimage(_paymentNumber, _chargeAmountInWei, _paymentMethod);
140             image = generatePrefixedPreimage(preimage);
141         } else {
142             image = generatePreimage(_paymentNumber, _chargeAmountInWei, _paymentMethod);
143         }
144         // ensure that the preimages construct properly
145         require(image == _h, "reconstructed preimage does not match");
146         address signer = ecrecover(_h, _v, _r, _s);
147         // ensure that we actually signed this message
148         require(signer == SIGNER, "recovered signer does not match");
149         PaymentStruct memory ps = PaymentStruct({
150             paymentNumber: _paymentNumber,
151             chargeAmountInWei: _chargeAmountInWei,
152             method: PaymentMethod(_paymentMethod),
153             state: PaymentState.paid
154         });
155         payments[msg.sender][_paymentNumber] = ps;
156         numPayments[msg.sender] = numPayments[msg.sender].add(1);
157         // if they are opting to pay in eth run this block of code, otherwise make the payment in RTC
158         if (PaymentMethod(_paymentMethod) == PaymentMethod.ETH) {
159             require(msg.value == _chargeAmountInWei, "msg.value does not equal charge amount");
160             emit PaymentMade(msg.sender, _paymentNumber, _paymentMethod, _chargeAmountInWei);
161             HOTWALLET.transfer(msg.value);
162             return true;
163         }
164         emit PaymentMade(msg.sender, _paymentNumber, _paymentMethod, _chargeAmountInWei);
165         require(RTI.transferFrom(msg.sender, HOTWALLET, _chargeAmountInWei), "trasferFrom failed, most likely needs approval");
166         return true;
167     }
168 
169     /** @notice This is a helper function used to verify whether or not the provided arguments can reconstruct the message hash
170         * @param _h This is the message hash which is signed, and will be reconstructed
171         * @param _paymentNumber This is the number of payment
172         * @param _paymentMethod This is the payment method (RTC, ETH) being used
173         * @param _chargeAmountInWei This is the amount the user is to be charged
174         * @param _prefixed This indicates whether the message was signed according to ERC191
175      */
176     function verifyImages(
177         bytes32 _h,
178         uint256 _paymentNumber,
179         uint8   _paymentMethod,
180         uint256 _chargeAmountInWei,
181         bool   _prefixed)
182         public
183         view
184         returns (bool)
185     {
186         require(_paymentMethod == 0 || _paymentMethod == 1, "invalid payment method");
187         bytes32 image;
188         if (_prefixed) {
189             bytes32 preimage = generatePreimage(_paymentNumber, _chargeAmountInWei, _paymentMethod);
190             image = generatePrefixedPreimage(preimage);
191         } else {
192             image = generatePreimage(_paymentNumber, _chargeAmountInWei, _paymentMethod);
193         }
194         return image == _h;
195     }
196 
197     /** @notice This is a helper function which can be used to verify the signer of a message
198         * @param _h This is the message hash that is signed
199         * @param _v This is pulled from the signature
200         * @param _r This is pulled from the signature
201         * @param _s This is pulled from the signature
202         * @param _paymentNumber This is the payment number of this particular payment
203         * @param _paymentMethod This is the payment method (RTC, ETH) being used
204         * @param _chargeAmountInWei This is the amount hte user is to be charged
205         * @param _prefixed This indicates whether or not the message was signed using ERC191
206      */
207     function verifySigner(
208         bytes32 _h,
209         uint8   _v,
210         bytes32 _r,
211         bytes32 _s,
212         uint256 _paymentNumber,
213         uint8   _paymentMethod,
214         uint256 _chargeAmountInWei,
215         bool   _prefixed)
216         public
217         view
218         returns (bool)
219     {
220         require(_paymentMethod == 0 || _paymentMethod == 1, "invalid payment method");
221         bytes32 image;
222         if (_prefixed) {
223             bytes32 preimage = generatePreimage(_paymentNumber, _chargeAmountInWei, _paymentMethod);
224             image = generatePrefixedPreimage(preimage);
225         } else {
226             image = generatePreimage(_paymentNumber, _chargeAmountInWei, _paymentMethod);
227         }
228         require(image == _h, "failed to reconstruct preimages");
229         return ecrecover(_h, _v, _r, _s) == SIGNER;
230     }
231 
232     /** @notice This is a helper function used to generate a non ERC191 signed message hash
233         * @param _paymentNumber This is the payment number of this payment
234         * @param _chargeAmountInWei This is the amount the user is to be charged
235         * @param _paymentMethod This is the payment method (RTC, ETH) being used
236      */
237     function generatePreimage(
238         uint256 _paymentNumber,
239         uint256 _chargeAmountInWei,
240         uint8   _paymentMethod)
241         internal
242         view
243         returns (bytes32)
244     {
245         return keccak256(abi.encodePacked(msg.sender, _paymentNumber, _paymentMethod, _chargeAmountInWei));
246     }
247 
248     /** @notice This is a helper function that prepends the ERC191 signed message prefix
249         * @param _preimage This is the reconstructed message hash before being prepened with the ERC191 prefix
250      */
251     function generatePrefixedPreimage(bytes32 _preimage) internal pure returns (bytes32)  {
252         return keccak256(abi.encodePacked(PREFIX, _preimage));
253     }
254 
255     /** @notice Used to destroy the contract
256      */
257     function goodNightSweetPrince() public onlyAdmin returns (bool) {
258         selfdestruct(msg.sender);
259         return true;
260     }
261 }