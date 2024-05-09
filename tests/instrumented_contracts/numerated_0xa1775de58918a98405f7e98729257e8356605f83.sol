1 pragma solidity ^0.5.12;
2 
3 // import "./ownership/Ownable.sol";
4 contract Context {
5     // Empty internal constructor, to prevent people from mistakenly deploying
6     // an instance of this contract, which should be used via inheritance.
7     constructor () internal { }
8     // solhint-disable-previous-line no-empty-blocks
9 
10     function _msgSender() internal view returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     /**
26      * @dev Initializes the contract setting the deployer as the initial owner.
27      */
28     constructor () internal {
29         address msgSender = _msgSender();
30         _owner = msgSender;
31         emit OwnershipTransferred(address(0), msgSender);
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(isOwner(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     /**
50      * @dev Returns true if the caller is the current owner.
51      */
52     function isOwner() public view returns (bool) {
53         return _msgSender() == _owner;
54     }
55 
56     /**
57      * @dev Leaves the contract without owner. It will not be possible to call
58      * `onlyOwner` functions anymore. Can only be called by the current owner.
59      *
60      * NOTE: Renouncing ownership will leave the contract without an owner,
61      * thereby removing any functionality that is only available to the owner.
62      */
63     function renounceOwnership() public onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      * Can only be called by the current owner.
71      */
72     function transferOwnership(address newOwner) public onlyOwner {
73         _transferOwnership(newOwner);
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      */
79     function _transferOwnership(address newOwner) internal {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 }
85 
86 contract KingdomPay is Ownable {
87     event Buy(uint256 code, uint256 value);
88     event Take(uint256 code, uint256 value);
89     
90     address payable private receiver;
91 
92     constructor() public
93     {
94     }
95 
96     function () payable external {}
97 
98     function take(uint256 code) public payable {
99         emit Take(code, msg.value);
100     }
101 
102     function buy(uint256 code) public payable {
103         emit Buy(code, msg.value);
104     }
105 
106     function setReceiver(address payable r) public onlyOwner{
107         receiver = r;
108     }
109 
110     function withdraw() public {
111         require(_msgSender() == receiver || _msgSender() == owner(), "Incorrect address");
112         receiver.transfer(address(this).balance);
113     }
114 }