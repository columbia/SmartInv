1 pragma solidity ^0.5.3;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner(), "Ownable: caller is not the owner");
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      * @notice Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 // good enough for a hackathon right?
76 contract BirdFeeder is Ownable {
77 
78    mapping (address => uint) public contributors;
79    mapping (uint => bool) public paid;
80    
81    address[8] public top8;
82 
83    uint public lowest; // index of loest entry sometimes
84    uint public lowestAmount; // amount of lowest top8 entry
85 
86    constructor() public{
87    }
88    
89    // fallback
90    function() external payable {
91 
92       // bump the users contribution
93       contributors[msg.sender] = contributors[msg.sender]+msg.value;
94       bool insert = true;
95 
96       // pass #1
97       for (uint i=0; i<8; i++) {
98         
99         // see if lowest needs updating
100         if(contributors[top8[i]] <= lowestAmount) {
101             
102             lowestAmount = contributors[top8[i]];
103             lowest = i;
104         }    
105         
106         // if user is already in top 8, we're done
107         if(top8[i]==msg.sender){
108             insert=false;
109         }
110         
111       }
112       
113       if(contributors[top8[lowest]] < contributors[msg.sender] && insert){
114         top8[lowest] = msg.sender; // replace the lowest memeber with 
115         lowestAmount = contributors[msg.sender];
116       }
117       // lets just say the most recent is the lowest now
118       // we'll correct that assumption before doing anything with it.
119    }
120    
121    // track users that get paid
122    function dispense(address payable dst, uint sum, uint userid) external onlyOwner {
123        require(paid[userid]==false);
124        paid[userid]=true;
125        dst.transfer(sum);
126    }
127    
128    function getBalance() public view returns (uint){
129        return address(this).balance;
130    }
131 
132 }