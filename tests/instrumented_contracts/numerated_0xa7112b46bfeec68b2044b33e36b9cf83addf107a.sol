1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     address public owner;
5 
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10     /**
11      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12      * account.
13      */
14     function Ownable() public {
15         owner = msg.sender;
16     }
17 
18     /**
19      * @dev Throws if called by any account other than the owner.
20      */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27      * @dev Allows the current owner to transfer control of the contract to a newOwner.
28      * @param newOwner The address to transfer ownership to.
29      */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 
36 }
37 library SafeMath {
38 
39     /**
40     * @dev Multiplies two numbers, reverts on overflow.
41     */
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44         // benefit is lost if 'b' is also tested.
45         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
46         if (a == 0) {
47             return 0;
48         }
49 
50         uint256 c = a * b;
51         require(c / a == b);
52 
53         return c;
54     }
55 
56     /**
57     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
58     */
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b > 0); // Solidity only automatically asserts when dividing by 0
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     /**
68     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69     */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78     * @dev Adds two numbers, reverts on overflow.
79     */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a);
83 
84         return c;
85     }
86 
87     /**
88     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
89     * reverts when dividing by zero.
90     */
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b != 0);
93         return a % b;
94     }
95 }
96 interface ERC20 {
97     function totalSupply() public view returns (uint supply);
98     function balanceOf(address _owner) public view returns (uint balance);
99     function transfer(address _to, uint _value) public returns (bool success);
100     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
101     function approve(address _spender, uint _value) public returns (bool success);
102     function allowance(address _owner, address _spender) public view returns (uint remaining);
103     function decimals() public view returns(uint digits);
104     event Approval(address indexed _owner, address indexed _spender, uint _value);
105 }
106 contract KyberNetworkProxy {
107 
108     function tradeWithHint(
109         ERC20 src,
110         uint srcAmount,
111         ERC20 dest,
112         address destAddress,
113         uint maxDestAmount,
114         uint minConversionRate,
115         address walletId,
116         bytes hint
117     )
118     public
119     payable
120     returns(uint);
121 
122     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
123     public view
124     returns(uint expectedRate, uint slippageRate);
125 }
126 
127 contract ProxyKyberSwap is Ownable{
128     using SafeMath for uint256;
129     KyberNetworkProxy public kyberNetworkProxyContract;
130     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
131     uint private proceesPer = 975;
132     //    address private ID = address(0xEc2E65258b0CB297F44f395f6fF13485A9D320DC);
133     //    address public ceo = address(0xEc2E65258b0CB297F44f395f6fF13485A9D320DC);
134     address private ID = address(0xEc2E65258b0CB297F44f395f6fF13485A9D320DC);
135     address public ceo = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
136     // Events
137     event Swap(address indexed sender, ERC20 srcToken, ERC20 destToken, uint256);
138     event SwapEth2Token(address indexed sender, string, ERC20 destToken);
139     modifier onlyCeo() {
140         require(msg.sender == ceo);
141         _;
142     }
143     modifier onlyManager() {
144         require(msg.sender == owner || msg.sender == ceo);
145         _;
146     }
147     // Functions
148     /**
149      * @dev Contract constructor
150      */
151     function ProxyKyberSwap() public {
152                 kyberNetworkProxyContract = KyberNetworkProxy(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);
153 //        kyberNetworkProxyContract = KyberNetworkProxy(0x692f391bCc85cefCe8C237C01e1f636BbD70EA4D);
154     }
155 
156     /**
157      * @dev Gets the conversion rate for the destToken given the srcQty.
158      * @param srcToken source token contract address
159      * @param srcQty amount of source tokens
160      * @param destToken destination token contract address
161      */
162     function getConversionRates(
163         ERC20 srcToken,
164         uint srcQty,
165         ERC20 destToken
166     ) public
167     view
168     returns (uint, uint, uint _proccessAmount)
169     {
170         uint minConversionRate;
171         uint spl;
172         (minConversionRate,spl) = kyberNetworkProxyContract.getExpectedRate(srcToken, destToken, srcQty);
173         uint ProccessAmount = calProccessAmount(minConversionRate);
174         return (minConversionRate, spl, ProccessAmount);
175     }
176 
177     /**
178      * @dev Swap the user's ERC20 token to another ERC20 token/ETH
179      * @param srcToken source token contract address
180      * @param srcQty amount of source tokens
181      * @param destToken destination token contract address
182      * @param destAddress address to send swapped tokens to
183      * @param maxDestAmount address to send swapped tokens to
184      */
185     function executeSwap(
186         ERC20 srcToken,
187         uint srcQty,
188         ERC20 destToken,
189         address destAddress,
190         uint maxDestAmount,
191         uint typeSwap
192     ) public payable{
193         uint minConversionRate;
194         bytes memory hint;
195         uint256 amountProccess = calProccessAmount(srcQty);
196         if(typeSwap == 1) {
197             require(srcToken.transferFrom(msg.sender, address(this), srcQty));
198             require(srcToken.approve(address(kyberNetworkProxyContract), amountProccess));
199         }
200 
201         // Get the minimum conversion rate
202         (minConversionRate,) = kyberNetworkProxyContract.getExpectedRate(srcToken, destToken, amountProccess);
203 
204         // // Swap the ERC20 token and send to destAddress
205         kyberNetworkProxyContract.tradeWithHint.value(calProccessAmount(msg.value))(
206             srcToken,
207             amountProccess,
208             destToken,
209             destAddress,
210             maxDestAmount,
211             minConversionRate,
212             ID, hint
213         );
214 
215         // Log the event
216         Swap(msg.sender, srcToken, destToken, msg.value);
217     }
218     function calProccessAmount(uint256 amount) internal view returns(uint256){
219         return amount.mul(proceesPer).div(1000);
220     }
221     function withdraw(ERC20[] tokens, uint256[] amounts) public onlyCeo{
222         owner.transfer((this).balance);
223         for(uint i = 0; i< tokens.length; i++) {
224             tokens[i].transfer(owner, amounts[i]);
225         }
226 
227     }
228     function getInfo() public view onlyManager returns (uint _proceesPer){
229         return proceesPer;
230     }
231     function setInfo(uint _proceesPer) public onlyManager{
232         proceesPer = _proceesPer;
233     }
234     function setCeo(address _ceo) public onlyCeo{
235         ceo = _ceo;
236     }
237 }