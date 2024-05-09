1 pragma solidity ^0.4.25;
2 
3 
4 /// @title Version
5 contract Version {
6     string public semanticVersion;
7 
8     /// @notice Constructor saves a public version of the deployed Contract.
9     /// @param _version Semantic version of the contract.
10     constructor(string _version) internal {
11         semanticVersion = _version;
12     }
13 }
14 
15 
16 /// @title Factory
17 contract Factory is Version {
18     event FactoryAddedContract(address indexed _contract);
19 
20     modifier contractHasntDeployed(address _contract) {
21         require(contracts[_contract] == false);
22         _;
23     }
24 
25     mapping(address => bool) public contracts;
26 
27     constructor(string _version) internal Version(_version) {}
28 
29     function hasBeenDeployed(address _contract) public constant returns (bool) {
30         return contracts[_contract];
31     }
32 
33     function addContract(address _contract)
34         internal
35         contractHasntDeployed(_contract)
36         returns (bool)
37     {
38         contracts[_contract] = true;
39         emit FactoryAddedContract(_contract);
40         return true;
41     }
42 }
43 
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50 contract Ownable {
51     address public owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57      * account.
58      */
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     /**
72      * @dev Allows the current owner to transfer control of the contract to a newOwner.
73      * @param newOwner The address to transfer ownership to.
74      */
75     function transferOwnership(address newOwner) public onlyOwner {
76         require(newOwner != address(0));
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79     }
80 }
81 
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 interface ERC20 {
88     function transfer(address to, uint256 value) external returns (bool);
89     function transferFrom(address from, address to, uint256 value) external returns (bool);
90     function approve(address spender, uint256 value) external returns (bool);
91     function totalSupply() external view returns (uint256);
92     function balanceOf(address who) external view returns (uint256);
93     function allowance(address owner, address spender) external view returns (uint256);
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 contract SpendableWallet is Ownable {
100     ERC20 public token;
101 
102     event ClaimedTokens(
103         address indexed _token,
104         address indexed _controller,
105         uint256 _amount
106     );
107 
108     constructor(address _token, address _owner) public {
109         token = ERC20(_token);
110         owner = _owner;
111     }
112 
113     function spend(address _to, uint256 _amount) public onlyOwner {
114         require(
115             token.transfer(_to, _amount),
116             "Token transfer could not be executed."
117         );
118     }
119 
120     /// @notice This method can be used by the controller to extract mistakenly
121     ///  sent tokens to this contract.
122     /// @param _token The address of the token contract that you want to recover
123     ///  set to 0 in case you want to extract ether.
124     function claimTokens(address _token) public onlyOwner {
125         if (_token == 0x0) {
126             owner.transfer(address(this).balance);
127             return;
128         }
129 
130         ERC20 erc20token = ERC20(_token);
131         uint256 balance = erc20token.balanceOf(address(this));
132         require(
133             erc20token.transfer(owner, balance),
134             "Token transfer could not be executed."
135         );
136         emit ClaimedTokens(_token, owner, balance);
137     }
138 }
139 
140 
141 contract SpendableWalletFactory is Factory {
142     // index of created contracts
143     address[] public spendableWallets;
144 
145     constructor() public Factory("1.0.3") {}
146 
147     // deploy a new contract
148     function newPaymentAddress(address _token, address _owner)
149         public
150         returns(address newContract)
151     {
152         SpendableWallet spendableWallet = new SpendableWallet(_token, _owner);
153         spendableWallets.push(spendableWallet);
154         addContract(spendableWallet);
155         return spendableWallet;
156     }
157 }