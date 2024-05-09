1 
2 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
3 
4 pragma solidity ^0.5.2;
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12     address private _owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     constructor () internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @return the address of the owner.
27      */
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner());
37         _;
38     }
39 
40     /**
41      * @return true if `msg.sender` is the owner of the contract.
42      */
43     function isOwner() public view returns (bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Allows the current owner to relinquish control of the contract.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      * @notice Renouncing ownership will leave the contract without an owner,
52      * thereby removing any functionality that is only available to the owner.
53      */
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58 
59     /**
60      * @dev Allows the current owner to transfer control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function _transferOwnership(address newOwner) internal {
72         require(newOwner != address(0));
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 // File: contracts/DAORegistry.sol
79 
80 pragma solidity ^0.5.4;
81 
82 
83 contract DAORegistry is Ownable {
84 
85     event Propose(address indexed _avatar);
86     event Register(address indexed _avatar, string _name);
87     event UnRegister(address indexed _avatar);
88 
89     mapping(string=>bool) private registry;
90 
91     constructor(address _owner) public {
92         transferOwnership(_owner);
93     }
94 
95     function propose(address _avatar) public {
96         emit Propose(_avatar);
97     }
98 
99     function register(address _avatar, string memory _name) public onlyOwner {
100         require(!registry[_name]);
101         registry[_name] = true;
102         emit Register(_avatar, _name);
103     }
104 
105     function unRegister(address _avatar) public onlyOwner {
106         emit UnRegister(_avatar);
107     }
108 
109     //This getter is needed because Dynamically-sized keys for public mappings are not supported.
110     function isRegister(string memory _name) public view returns(bool) {
111         return registry[_name];
112     }
113 
114 }
