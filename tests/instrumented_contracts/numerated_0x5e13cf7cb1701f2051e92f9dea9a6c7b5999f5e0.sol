1 pragma solidity ^0.4.18;
2 
3 /*
4     ERC20 Standard Token interface
5 */
6 contract IERC20Token {
7     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
8     function name() public constant returns (string) {}
9     function symbol() public constant returns (string) {}
10     function decimals() public constant returns (uint8) {}
11     function totalSupply() public constant returns (uint256) {}
12     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
13     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
14 
15     function transfer(address _to, uint256 _value) public returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 }
19 
20 ///@title - a contract that represents a smart wallet, created by Stox, for every new Stox user
21 library SmartWalletLib {
22 
23     /*
24      *  Structs
25      */
26     struct Wallet {
27         address operatorAccount;
28         address backupAccount;
29         address userWithdrawalAccount;
30         address feesAccount;
31     }
32 
33     /*
34      *  Members
35      */
36     string constant VERSION = "0.1";
37    
38 
39     /*
40      *  Modifiers
41      */
42     modifier validAddress(address _address) {
43         require(_address != 0x0);
44         _;
45     }
46 
47     modifier addressNotSet(address _address) {
48         require(_address == 0);
49         _;
50     }
51 
52     modifier operatorOnly(address _operatorAccount) {
53         require(msg.sender == _operatorAccount);
54         _;
55     }
56 
57     /*
58      *  Events
59      */
60     event TransferToBackupAccount(address _token, address _backupAccount, uint _amount);
61     event TransferToUserWithdrawalAccount(address _token, address _userWithdrawalAccount, uint _amount, address _feesToken, address _feesAccount, uint _fee);
62     event SetUserWithdrawalAccount(address _userWithdrawalAccount);
63 
64     /*
65         @dev Initialize the wallet with the operator and backupAccount address
66         
67         @param _self                        Wallet storage
68         @param _backupAccount               Operator account to release funds in case the user lost his withdrawal account
69         @param _operator                    The operator account
70         @param _feesAccount                 The account to transfer fees to
71     */
72     function initWallet(Wallet storage _self, address _backupAccount, address _operator, address _feesAccount) 
73             public
74             validAddress(_backupAccount)
75             validAddress(_operator)
76             validAddress(_feesAccount)
77             {
78         
79                 _self.operatorAccount = _operator;
80                 _self.backupAccount = _backupAccount;
81                 _self.feesAccount = _feesAccount;
82     }
83 
84     /*
85         @dev Setting the account of the user to send funds to. 
86         
87         @param _self                        Wallet storage
88         @param _userWithdrawalAccount       The user account to withdraw funds to
89     */
90     function setUserWithdrawalAccount(Wallet storage _self, address _userWithdrawalAccount) 
91             public
92             operatorOnly(_self.operatorAccount)
93             validAddress(_userWithdrawalAccount)
94             addressNotSet(_self.userWithdrawalAccount)
95             {
96         
97                 _self.userWithdrawalAccount = _userWithdrawalAccount;
98                 SetUserWithdrawalAccount(_userWithdrawalAccount);
99     }
100 
101     /*
102         @dev Withdraw funds to a backup account. 
103 
104 
105         @param _self                Wallet storage
106         @param _token               The ERC20 token the owner withdraws from 
107         @param _amount              Amount to transfer    
108     */
109     function transferToBackupAccount(Wallet storage _self, IERC20Token _token, uint _amount) 
110             public 
111             operatorOnly(_self.operatorAccount)
112             {
113         
114                 _token.transfer(_self.backupAccount, _amount);
115                 TransferToBackupAccount(_token, _self.backupAccount, _amount); 
116     }
117       
118     /*
119         @dev Withdraw funds to the user account. 
120 
121         @param _self                Wallet storage
122         @param _token               The ERC20 token the owner withdraws from 
123         @param _amount              Amount to transfer  
124         @param _fee                 Fee to transfer   
125     */
126     function transferToUserWithdrawalAccount(Wallet storage _self, IERC20Token _token, uint _amount, IERC20Token _feesToken, uint _fee) 
127             public 
128             operatorOnly(_self.operatorAccount)
129             validAddress(_self.userWithdrawalAccount)
130             {
131 
132                 if (_fee > 0) {        
133                     _feesToken.transfer(_self.feesAccount, _fee); 
134                 }       
135                 
136                 _token.transfer(_self.userWithdrawalAccount, _amount);
137                 TransferToUserWithdrawalAccount(_token, _self.userWithdrawalAccount, _amount,  _feesToken, _self.feesAccount, _fee);   
138         
139     }
140 }
141 
142 ///@title - a contract that represents a smart wallet, created by Stox, for every new Stox user
143 contract SmartWallet {
144 
145     /*
146      *  Members
147      */
148     using SmartWalletLib for SmartWalletLib.Wallet;
149     SmartWalletLib.Wallet public wallet;
150        
151    // Wallet public wallet;
152     /*
153      *  Events
154      */
155     event TransferToBackupAccount(address _token, address _backupAccount, uint _amount);
156     event TransferToUserWithdrawalAccount(address _token, address _userWithdrawalAccount, uint _amount, address _feesToken, address _feesAccount, uint _fee);
157     event SetUserWithdrawalAccount(address _userWithdrawalAccount);
158      
159     /*
160         @dev constructor
161 
162         @param _backupAccount       A default operator's account to send funds to, in cases where the user account is
163                                     unavailable or lost
164         @param _operator            The contract operator address
165         @param _feesAccount         The account to transfer fees to 
166 
167     */
168     function SmartWallet(address _backupAccount, address _operator, address _feesAccount) public {
169         wallet.initWallet(_backupAccount, _operator, _feesAccount);
170     }
171 
172     /*
173         @dev Setting the account of the user to send funds to. 
174         
175         @param _userWithdrawalAccount       The user account to withdraw funds to
176         
177     */
178     function setUserWithdrawalAccount(address _userWithdrawalAccount) public {
179         wallet.setUserWithdrawalAccount(_userWithdrawalAccount);
180     }
181 
182     /*
183         @dev Withdraw funds to a backup account. 
184 
185 
186         @param _token               The ERC20 token the owner withdraws from 
187         @param _amount              Amount to transfer    
188     */
189     function transferToBackupAccount(IERC20Token _token, uint _amount) public {
190         wallet.transferToBackupAccount(_token, _amount);
191     }
192 
193     /*
194         @dev Withdraw funds to the user account. 
195 
196 
197         @param _token               The ERC20 token the owner withdraws from 
198         @param _amount              Amount to transfer    
199     */
200     function transferToUserWithdrawalAccount(IERC20Token _token, uint _amount, IERC20Token _feesToken, uint _fee) public {
201         wallet.transferToUserWithdrawalAccount(_token, _amount, _feesToken, _fee);
202     }
203 }