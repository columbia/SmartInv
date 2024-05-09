1 pragma solidity ^0.5.9;
2 
3 
4 contract Ownable {
5     address private _owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     /**
10      * @dev Initializes the contract setting the deployer as the initial owner.
11      */
12     constructor() internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @dev Returns the address of the current owner.
19      */
20     function owner() external view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == _owner, "Ownable: caller is not the owner");
29         _;
30     }
31 
32     /**
33      * @dev Transfers ownership of the contract to a new account (`newOwner`).
34      * Can only be called by the current owner.
35      */
36     function transferOwnership(address newOwner) external onlyOwner {
37         require(newOwner != address(0), "Ownable: new owner is the zero address");
38         emit OwnershipTransferred(_owner, newOwner);
39         _owner = newOwner;
40     }
41 }
42 
43 
44 
45 // File: contracts/commons/Wallet.sol
46 
47 pragma solidity ^0.5.9;
48 
49 
50 
51 contract Wallet is Ownable {
52     function execute(
53         address payable _to,
54         uint256 _value,
55         bytes calldata _data
56     ) external onlyOwner returns (bool, bytes memory) {
57         return _to.call.value(_value)(_data);
58     }
59 }
60 
61 interface NanoLoanEngine {
62     function transferFrom(address from, address to, uint256 index) external returns (bool);
63 }
64 
65 contract LoanPull is Ownable, Wallet {
66     event Pulling(address _engine, address _from, address _to, uint256 _ids);
67     event Pulled(uint256 _id, bool _success);
68 
69     function pullLoans(
70         NanoLoanEngine _engine,
71         address _from,
72         address _to,
73         uint256[] calldata _ids
74     ) external onlyOwner {
75         uint256 len = _ids.length;
76 
77         emit Pulling(address(_engine), _from, _to, len);
78 
79         for (uint256 i = 0; i < len; i++) {
80             uint256 id = _ids[i];
81             bool success = _engine.transferFrom(_from, _to, id);
82             emit Pulled(id, success);
83         }
84     }
85 }