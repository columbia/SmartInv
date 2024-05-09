1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipRenounced(address indexed previousOwner);
14     event OwnershipTransferred(
15         address indexed previousOwner,
16         address indexed newOwner
17     );
18 
19 
20     /**
21     * The Ownable constructor sets the original `owner` of the contract to the sender
22     * account.
23     */
24     constructor() public {
25         owner = msg.sender;
26     }
27 
28     /**
29     * Throws if called by any account other than the owner.
30     */
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     /**
37     * Allows the current owner to relinquish control of the contract.
38     * @notice Renouncing to ownership will leave the contract without an owner.
39     * It will not be possible to call the functions with the `onlyOwner`
40     * modifier anymore.
41     */
42     function renounceOwnership() public onlyOwner {
43         emit OwnershipRenounced(owner);
44         owner = address(0);
45     }
46 
47     /**
48     * Allows the current owner to transfer control of the contract to a newOwner.
49     * @param _newOwner The address to transfer ownership to.
50     */
51     function transferOwnership(address _newOwner) public onlyOwner {
52         _transferOwnership(_newOwner);
53     }
54 
55     /**
56     * Transfers control of the contract to a newOwner.
57     * @param _newOwner The address to transfer ownership to.
58     */
59     function _transferOwnership(address _newOwner) internal {
60         require(_newOwner != address(0));
61         emit OwnershipTransferred(owner, _newOwner);
62         owner = _newOwner;
63     }
64 }
65 
66 
67 contract ERC20Basic {
68     function totalSupply() public view returns (uint256);
69     function balanceOf(address who) public view returns (uint256);
70     function transfer(address to, uint256 value) public returns (bool);
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 contract ERC20 is ERC20Basic {
75     function allowance(address owner, address spender)
76         public view returns (uint256);
77 
78     function transferFrom(address from, address to, uint256 value)
79         public returns (bool);
80 
81     function approve(address spender, uint256 value) public returns (bool);
82     event Approval(
83         address indexed owner,
84         address indexed spender,
85         uint256 value
86     );
87 }
88 
89 
90 contract AirDropper is Ownable {
91 
92     function multisend(address _tokenAddr, address[] dests, uint256[] values) public onlyOwner returns (uint256) {
93         uint256 i = 0;
94         while (i < dests.length) {
95            ERC20(_tokenAddr).transfer(dests[i], values[i]);
96            i += 1;
97         }
98         return(i);
99     }
100 }