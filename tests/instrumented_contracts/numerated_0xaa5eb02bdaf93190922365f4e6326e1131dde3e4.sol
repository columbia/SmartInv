1 pragma solidity ^0.4.18;
2 
3 library SafeERC20 {
4   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
5     assert(token.transfer(to, value));
6   }
7 
8   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
9     assert(token.transferFrom(from, to, value));
10   }
11 
12   function safeApprove(ERC20 token, address spender, uint256 value) internal {
13     assert(token.approve(spender, value));
14   }
15 }
16 
17 contract ERC20Basic {
18   uint256 public totalSupply;
19   function balanceOf(address who) public view returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22   
23 }
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) public view returns (uint256);
26   function transferFrom(address from, address to, uint256 value) public returns (bool);
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 contract HasWallet is Ownable {
67     address public wallet;
68 
69     function setWallet(address walletAddress) public onlyOwner {
70         require(walletAddress != address(0));
71         wallet = walletAddress;
72     }
73 
74 
75 }
76 contract WalletUsage is HasWallet {
77 
78 
79     /**
80       * 合约自己是否保留eth.
81       */
82     bool public keepEth;
83 
84 
85     /**
86       * 为避免默认方法被占用，特别开指定方法接受以太坊
87       */
88     function depositEth() public payable {
89     }
90 
91     function withdrawEth2Wallet(uint256 weiAmount) public onlyOwner {
92         require(wallet != address(0));
93         require(weiAmount > 0);
94         wallet.transfer(weiAmount);
95     }
96 
97     function setKeepEth(bool _keepEth) public onlyOwner {
98         keepEth = _keepEth;
99     }
100 
101 }
102 
103 
104 contract PublicBatchTransfer is WalletUsage {
105     using SafeERC20 for ERC20;
106 
107     uint256 public fee;
108 
109     function PublicBatchTransfer(address walletAddress,uint256 _fee){
110         require(walletAddress != address(0));
111         setWallet(walletAddress);
112         setFee(_fee);
113     }
114 
115     function batchTransfer(address tokenAddress, address[] beneficiaries, uint256[] tokenAmount) payable public returns (bool) {
116         require(msg.value >= fee);
117         require(tokenAddress != address(0));
118         require(beneficiaries.length > 0 && beneficiaries.length == tokenAmount.length);
119         ERC20 ERC20Contract = ERC20(tokenAddress);
120         for (uint256 i = 0; i < beneficiaries.length; i++) {
121             ERC20Contract.safeTransferFrom(msg.sender, beneficiaries[i], tokenAmount[i]);
122         }
123         if (!keepEth) {
124             wallet.transfer(msg.value);
125         }
126 
127         return true;
128     }
129 
130     function setFee(uint256 _fee) onlyOwner public {
131         fee = _fee;
132     }
133 }