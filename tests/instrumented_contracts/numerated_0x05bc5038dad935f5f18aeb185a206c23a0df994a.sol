1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.18;
4 
5 abstract contract Ownable {
6     address private _owner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9     
10     /**
11      * @dev Initializes the contract setting the deployer as the initial owner.
12      */
13     constructor () {
14         address msgSender = msg.sender;
15         _owner = msgSender;
16         emit OwnershipTransferred(address(0), msgSender);
17     }
18 
19     /**
20      * @dev Returns the address of the current owner.
21      */
22     function owner() public view returns (address) {
23         return _owner;
24     }
25 
26     /**
27      * @dev Throws if called by any account other than the owner.
28      */
29     modifier onlyOwner() {
30         require(_owner == msg.sender, "Ownable: caller is not the owner");
31         _;
32     }
33 
34     /**
35      * @dev Leaves the contract without owner. It will not be possible to call
36      * `onlyOwner` functions anymore. Can only be called by the current owner.
37      *
38      * NOTE: Renouncing ownership will leave the contract without an owner,
39      * thereby removing any functionality that is only available to the owner.
40      */
41     function renounceOwnership() public virtual onlyOwner {
42         emit OwnershipTransferred(_owner, address(0));
43         _owner = address(0);
44     }
45 
46     /**
47      * @dev Transfers ownership of the contract to a new account (`newOwner`).
48      * Can only be called by the current owner.
49      */
50     function transferOwnership(address newOwner) public virtual onlyOwner {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         emit OwnershipTransferred(_owner, newOwner);
53         _owner = newOwner;
54     }
55 }
56 
57 contract HushMixer is Ownable {
58     mapping(bytes32 => bool) public deposits;
59     mapping(bytes32 => bool) public withdrawals;
60     
61     uint256 public withdrawalFee = 10; 
62     uint256 public accumulatedFees = 0;
63 
64     uint256 public constant MAX_WITHDRAWAL_FEE = 30;
65     uint256 public constant FEE_DENOMINATOR = 1000;
66     
67     constructor(){}
68 
69     function deposit(bytes32 commit) payable external {
70         require(msg.value == 0.1 ether || msg.value == 0.2 ether || msg.value == 0.5 ether || 
71             msg.value == 1 ether || msg.value == 10 ether, "HushMixer: deposit amount invalid");
72         require(deposits[commit] == false, "HushMixer: commit already deposited");
73         deposits[commit] = true;
74     }
75     
76     function withdraw(bytes32 key, address payable receiver, uint256 amount) external onlyOwner {
77         require(withdrawals[key] == false, "HushMixer: deposit already withdrawn");
78         require(amount == 0.1 ether || amount == 0.2 ether || amount == 0.5 ether || 
79             amount == 1 ether || amount == 10 ether, "HushMixer: withdraw amount invalid");
80         uint256 fees = amount * withdrawalFee / FEE_DENOMINATOR;
81         if(fees > 0){
82             accumulatedFees+= fees;
83             amount-=fees;
84         }
85         receiver.transfer(amount);
86         withdrawals[key] = true;
87     }
88 
89     function updateFee(uint256 newWithdrawalFeeBase1000) external onlyOwner {        
90         require(newWithdrawalFeeBase1000 <= MAX_WITHDRAWAL_FEE, 
91             "HushMixer: excessive fee rate (max 3%)");
92         withdrawalFee = newWithdrawalFeeBase1000;
93     }
94 
95     function claimFees() external onlyOwner {       
96         require(accumulatedFees > 0, "HushMixer: no fees to claim");
97         payable(owner()).transfer(accumulatedFees);
98         accumulatedFees = 0;
99     }
100 }