1 /*
2 
3 ██╗██████╗  ██████╗██╗     ██╗   ██╗██████╗    ██╗  ██╗██╗   ██╗███████╗
4 ██║██╔══██╗██╔════╝██║     ██║   ██║██╔══██╗   ╚██╗██╔╝╚██╗ ██╔╝╚══███╔╝
5 ██║██║  ██║██║     ██║     ██║   ██║██████╔╝    ╚███╔╝  ╚████╔╝   ███╔╝ 
6 ██║██║  ██║██║     ██║     ██║   ██║██╔══██╗    ██╔██╗   ╚██╔╝   ███╔╝  
7 ██║██████╔╝╚██████╗███████╗╚██████╔╝██████╔╝██╗██╔╝ ██╗   ██║   ███████╗
8 ╚═╝╚═════╝  ╚═════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝
9                                                                         
10 */
11 pragma solidity ^0.8.0;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 pragma solidity ^0.8.0;
24 
25 abstract contract Ownable is Context {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     /**
31      * @dev Initializes the contract setting the deployer as the initial owner.
32      */
33     constructor() {
34         _transferOwnership(_msgSender());
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         _checkOwner();
42         _;
43     }
44 
45     /**
46      * @dev Returns the address of the current owner.
47      */
48     function owner() public view virtual returns (address) {
49         return _owner;
50     }
51 
52     /**
53      * @dev Throws if the sender is not the owner.
54      */
55     function _checkOwner() internal view virtual {
56         require(owner() == _msgSender(), "Ownable: caller is not the owner");
57     }
58 
59     /**
60      * @dev Leaves the contract without owner. It will not be possible to call
61      * `onlyOwner` functions anymore. Can only be called by the current owner.
62      *
63      * NOTE: Renouncing ownership will leave the contract without an owner,
64      * thereby removing any functionality that is only available to the owner.
65      */
66     function renounceOwnership() public virtual onlyOwner {
67         _transferOwnership(address(0));
68     }
69 
70     /**
71      * @dev Transfers ownership of the contract to a new account (`newOwner`).
72      * Can only be called by the current owner.
73      */
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         _transferOwnership(newOwner);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Internal function without access restriction.
82      */
83     function _transferOwnership(address newOwner) internal virtual {
84         address oldOwner = _owner;
85         _owner = newOwner;
86         emit OwnershipTransferred(oldOwner, newOwner);
87     }
88 }
89 
90 pragma solidity >=0.8.4;
91 
92 contract OrdinalSats is Ownable {
93 	event InscribeSats(address indexed sender, string order,uint256 value);
94 	function inscribe(
95 		string memory order
96 	) public payable {
97 		emit InscribeSats(msg.sender, order, msg.value);
98 	}
99 
100 	function withdraw() public onlyOwner {
101 		payable(owner()).transfer(address(this).balance);
102 	}
103 }