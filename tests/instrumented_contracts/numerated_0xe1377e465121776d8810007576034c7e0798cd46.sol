1 pragma solidity 0.4.19;
2 
3 
4 contract Ownable {
5     
6     address public owner;
7 
8     /**
9      * The address whcih deploys this contrcat is automatically assgined ownership.
10      * */
11     function Ownable() public {
12         owner = msg.sender;
13     }
14 
15     /**
16      * Functions with this modifier can only be executed by the owner of the contract. 
17      * */
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     event OwnershipTransferred(address indexed from, address indexed to);
24 
25     /**
26     * Transfers ownership to new Ethereum address. This function can only be called by the 
27     * owner.
28     * @param _newOwner the address to be granted ownership.
29     **/
30     function transferOwnership(address _newOwner) public onlyOwner {
31         require(_newOwner != 0x0);
32         OwnershipTransferred(owner, _newOwner);
33         owner = _newOwner;
34     }
35 }
36 
37 
38 
39 
40 contract ERC20TransferInterface {
41     function transfer(address to, uint256 value) public returns (bool);
42     function balanceOf(address who) constant public returns (uint256);
43 }
44 
45 
46 
47 
48 contract MultiSigWallet is Ownable {
49 
50     event AddressAuthorised(address indexed addr);
51     event AddressUnauthorised(address indexed addr);
52     event TransferOfEtherRequested(address indexed by, address indexed to, uint256 valueInWei);
53     event EthTransactionConfirmed(address indexed by);
54     event EthTransactionRejected(address indexed by);
55     event TransferOfErc20Requested(address indexed by, address indexed to, address indexed token, uint256 value);
56     event Erc20TransactionConfirmed(address indexed by);
57     event Erc20TransactionRejected(address indexed by);
58 
59     /**
60     * Struct exists to hold data associated with the requests of ETH transactions. 
61     **/
62     struct EthTransactionRequest {
63         address _from;
64         address _to;
65         uint256 _valueInWei;
66     }
67 
68     /**
69     * Struct exists to hold data associated with the requests of ERC20 token transactions. 
70     **/
71     struct Erc20TransactionRequest {
72         address _from;
73         address _to;
74         address _token;
75         uint256 _value;
76     }
77 
78     EthTransactionRequest public latestEthTxRequest;
79     Erc20TransactionRequest public latestErc20TxRequest;
80 
81     mapping (address => bool) public isAuthorised;
82 
83 
84     /**
85     * Constructor initializes the isOwner mapping. 
86     **/
87     function MultiSigWallet() public {
88  
89         isAuthorised[0xF748D2322ADfE0E9f9b262Df6A2aD6CBF79A541A] = true; //account 1
90         isAuthorised[0x4BbBbDd42c7aab36BeA6A70a0cB35d6C20Be474E] = true; //account 2
91         isAuthorised[0x2E661Be8C26925DDAFc25EEe3971efb8754E6D90] = true; //account 3
92         isAuthorised[0x1ee9b4b8c9cA6637eF5eeCEE62C9e56072165AAF] = true; //account 4
93 
94     }
95 
96     modifier onlyAuthorisedAddresses {
97         require(isAuthorised[msg.sender] = true);
98         _;
99     }
100 
101     modifier validEthConfirmation {
102         require(msg.sender != latestEthTxRequest._from);
103         _;
104     }
105 
106     modifier validErc20Confirmation {
107         require(msg.sender != latestErc20TxRequest._from);
108         _;
109     }
110 
111     /**
112     * Fallback function makes it possible for the contract to receive ETH. 
113     **/
114     function() public payable { }
115 
116     /**
117     * Allows the owner to authorise an address to approve and request the transfer of ETH and
118     * ERC20 tokens.
119     **/
120     function authoriseAddress(address _addr) public onlyOwner {
121         require(_addr != 0x0 && !isAuthorised[_addr]);
122         isAuthorised[_addr] = true;
123         AddressAuthorised(_addr);
124     }
125 
126     /**
127     * Allows the owner to unauthorise an address from approving or requesting the transfer of ETH
128     * and ERC20 tokens.
129     **/
130     function unauthoriseAddress(address _addr) public onlyOwner {
131         require(isAuthorised[_addr] && _addr != owner);
132         isAuthorised[_addr] = false;
133         AddressUnauthorised(_addr);
134     }
135 
136     /**
137     * Creates an ETH transaction request which will be stored in the contract's state. The transaction
138     * will only go through if it is confirmed by at least one more owner address. If this function is 
139     * called before a previous ETH transaction request has been confirmed, then it will be overridden. This
140     * function can only be called by one of the owner addresses. 
141     * 
142     * @param _to The address of the recipient
143     * @param _valueInWei The amount of ETH to send specified in units of wei
144     **/
145     function requestTransferOfETH(address _to, uint256 _valueInWei) public onlyAuthorisedAddresses {
146         require(_to != 0x0 && _valueInWei > 0);
147         latestEthTxRequest = EthTransactionRequest(msg.sender, _to, _valueInWei);
148         TransferOfEtherRequested(msg.sender, _to, _valueInWei);
149     }
150 
151     /**
152     * Creates an ERC20 transaction request which will be stored in the contract's state. The transaction
153     * will only go through if it is confirmed by at least one more owner address. If this function is 
154     * called before a previous ERC20 transaction request has been confirmed, then it will be overridden. This
155     * function can only be called by one of the owner addresses. 
156     * 
157     * @param _token The address of the ERC20 token contract
158     * @param _to The address of the recipient
159     * @param _value The amount of tokens to be sent
160     **/
161     function requestErc20Transfer(address _token, address _to, uint256 _value) public onlyAuthorisedAddresses {
162         ERC20TransferInterface token = ERC20TransferInterface(_token);
163         require(_to != 0x0 && _value > 0 && token.balanceOf(address(this)) >= _value);
164         latestErc20TxRequest = Erc20TransactionRequest(msg.sender, _to, _token, _value);
165         TransferOfErc20Requested(msg.sender, _to, _token, _value);
166     }
167 
168     /**
169     * Confirms previously requested ETH transactions. This function can only be called by one of the owner addresses
170     * excluding the address which initially made the request. 
171     **/
172     function confirmEthTransactionRequest() public onlyAuthorisedAddresses validEthConfirmation  {
173         require(isAuthorised[latestEthTxRequest._from] && latestEthTxRequest._to != 0x0 && latestEthTxRequest._valueInWei > 0);
174         latestEthTxRequest._to.transfer(latestEthTxRequest._valueInWei);
175         latestEthTxRequest = EthTransactionRequest(0x0, 0x0, 0);
176         EthTransactionConfirmed(msg.sender);
177     }
178 
179     /**
180     * Confirms previously requested ERC20 transactions. This function can only be called by one of the owner addresses
181     * excluding the address which initially made the request. 
182     **/
183     function confirmErc20TransactionRequest() public onlyAuthorisedAddresses validErc20Confirmation {
184         require(isAuthorised[latestErc20TxRequest._from] && latestErc20TxRequest._to != 0x0 && latestErc20TxRequest._value != 0 && latestErc20TxRequest._token != 0x0);
185         ERC20TransferInterface token = ERC20TransferInterface(latestErc20TxRequest._token);
186         token.transfer(latestErc20TxRequest._to,latestErc20TxRequest._value);
187         latestErc20TxRequest = Erc20TransactionRequest(0x0, 0x0, 0x0, 0);
188         Erc20TransactionConfirmed(msg.sender);
189     }
190 
191     /**
192     * Rejects ETH transaction requests and erases all data associated with the request. This function can only be called
193     * by one of the owner addresses. 
194     **/
195     function rejectEthTransactionRequest() public onlyAuthorisedAddresses {
196         latestEthTxRequest = EthTransactionRequest(0x0, 0x0, 0);
197         EthTransactionRejected(msg.sender);
198     }
199 
200     /**
201     * Rejects ERC20 transaction requests and erases all data associated with the request. This function can only be called
202     * by one of the owner addresses. 
203     **/
204     function rejectErx20TransactionRequest() public onlyAuthorisedAddresses {
205         latestErc20TxRequest = Erc20TransactionRequest(0x0, 0x0, 0x0, 0);
206         Erc20TransactionRejected(msg.sender);
207     }
208 
209     /**
210     * Returns the data associated with the latest ETH transaction request in the form of a touple. This data includes:
211     * the owner address which requested the transfer, the address of the recipient and the value of the transfer 
212     * specified in units of wei. 
213     **/
214     function viewLatestEthTransactionRequest() public view returns(address from, address to, uint256 valueInWei) {
215         return (latestEthTxRequest._from, latestEthTxRequest._to, latestEthTxRequest._valueInWei);
216     }
217 
218     /**
219     * Returns the data associated with the latest ERC20 transaction request in the form of a touple. This data includes:
220     * the owner address which requested the transfer, the address of the recipient, the address of the ERC20 token contract
221     * and the amount of tokens to send. 
222     **/
223     function viewLatestErc20TransactionRequest() public view returns(address from, address to, address token, uint256 value) {
224         return(latestErc20TxRequest._from, latestErc20TxRequest._to, latestErc20TxRequest._token, latestErc20TxRequest._value);
225     }
226 }