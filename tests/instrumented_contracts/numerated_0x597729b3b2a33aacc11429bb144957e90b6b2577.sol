1 pragma solidity ^0.4.16;
2 
3 contract ERC20Interface {
4     function transfer(address to, uint tokens) public returns (bool success);
5     function transferFrom(address from, address to, uint tokens) public returns (bool success);
6 }
7 
8 contract HmcDistributor {
9 
10     //add limit to 1 year
11     uint64  public constant lockDuration   = 1 minutes;
12     //Bonus amount
13     uint256 public constant bonus          = 5*10**18;
14     //add limit to 7000000 block height
15     uint    public constant minBlockNumber = 5000000;
16 
17     address public owner;
18     address public hmcAddress;
19 
20     uint256 public joinCount        = 0;
21     uint256 public withdrawCount    = 0;
22     uint256 public distributorCount = 0;
23 
24     struct member {
25         uint unlockTime;
26         bool withdraw;
27     }
28 
29     mapping(address => member)   public whitelist;
30     mapping(address => bool)     public distributors;
31 
32     modifier onlyDistributor {
33         require(distributors[msg.sender] == true);
34         _;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function HmcDistributor() public {
43         owner = msg.sender;
44         distributors[msg.sender] = true;
45         hmcAddress = 0xAa0bb10CEc1fa372eb3Abc17C933FC6ba863DD9E;
46     }
47 
48     /**
49     * @dev Allows the current owner to transfer control of the contract to a newOwner.
50     * @param newOwner The address to transfer ownership to.
51     */
52     function transferOwnership(address newOwner) public onlyOwner {
53         if (newOwner != address(0)) {
54             owner = newOwner;
55         }
56     }
57 
58     function setDistributor(address []_addr)
59         external
60         onlyOwner
61     {
62         uint256 index;
63         for(index = 0;index< _addr.length;index ++) {
64             distributors[_addr[index]] = true;
65         }
66         distributorCount += _addr.length;
67     }
68 
69     function setHmcAddress(address _addr)
70         external
71         onlyOwner
72     {
73         require(_addr != 0x0);
74         hmcAddress = _addr;
75     }
76 
77     function distribute(address _addr)
78         external
79         onlyDistributor
80     {
81         require(hmcAddress != address(0));
82         require(whitelist[_addr].unlockTime == 0);
83         whitelist[_addr].unlockTime = now + lockDuration;
84         joinCount++;
85     }
86 
87     function done(address _owner) external view returns (bool) {
88         if(whitelist[_owner].unlockTime == 0   ||
89            whitelist[_owner].withdraw   == true) {
90             return false;
91         }
92         if(now >= whitelist[_owner].unlockTime && block.number > minBlockNumber) {
93             return true;
94         }else{
95             return false;
96         }
97     }
98 
99     function withdraw() external {
100         require(withdrawCount<joinCount);
101         require(whitelist[msg.sender].withdraw == false);
102         require(whitelist[msg.sender].unlockTime > 1500000000);
103         require(now >= whitelist[msg.sender].unlockTime && block.number > minBlockNumber);
104         whitelist[msg.sender].withdraw = true;
105         withdrawCount++;
106         require(ERC20Interface(hmcAddress).transfer(msg.sender, bonus));
107     }
108 }