1 pragma solidity ^0.5.0;
2 
3 contract Ownable {
4     address payable public owner;
5     constructor () public {owner = msg.sender;}
6     modifier onlyOwner() {require(msg.sender == owner, "Only owner can call");_;}
7     function transferOwnership(address payable newOwner) external onlyOwner {
8         if(newOwner != address(0)){owner = newOwner;}
9     }
10 }
11 
12 interface IERC20 {
13     function transfer(address to, uint256 value) external returns (bool);
14     function approve(address spender, uint256 value) external returns (bool);
15     function transferFrom(address from, address to, uint256 value) external returns (bool);
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address who) external view returns (uint256);
18     function allowance(address owner, address spender) external view returns (uint256);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 contract RemiAirdrop is Ownable{
24     // Notify when contract deployed
25     event contractDeployed();
26     
27 
28     // State Variable that affects to airdropToken function
29     address public SOURCE_ADDRESS;
30     uint public DEFAULT_AMOUNT;
31     IERC20 public REMI_INTERFACE;
32     
33 
34     // Set state variables simultaneously with construct
35     constructor (address _tokenAddress, address _sourceAddress, uint _defaultAmount) public{
36         REMI_INTERFACE = IERC20(_tokenAddress);
37         SOURCE_ADDRESS = _sourceAddress;
38         DEFAULT_AMOUNT = _defaultAmount;
39         
40         emit contractDeployed();
41     }
42     
43     // Airdrop token from SOURCE_ADDRESS a _dropAmount per each _recipientList[i] via REMI_INTERFACE
44     function airdropToken(address[] calldata _recipientList, uint _dropAmount) external onlyOwner{
45         uint dropAmount = (_dropAmount > 0 ? _dropAmount : DEFAULT_AMOUNT) * 10**18;
46         require(_recipientList.length * dropAmount <= REMI_INTERFACE.allowance(SOURCE_ADDRESS,address(this)), "Allowed authority insufficient");
47         
48         for(uint i = 0; i < _recipientList.length; i++){
49             REMI_INTERFACE.transferFrom(SOURCE_ADDRESS, _recipientList[i], dropAmount);
50         }
51     }
52 
53     // Set each state variable manually
54     function setTokenAddress(address _newToken) external onlyOwner{
55         REMI_INTERFACE = IERC20(_newToken);
56     }
57     function setSourceAddress(address _newSource) external onlyOwner{
58         SOURCE_ADDRESS = _newSource;
59     }
60     function setDefaultAmount(uint _newAmount) external onlyOwner{
61         DEFAULT_AMOUNT = _newAmount;
62     }
63 
64     // Self destruct and refund balance to owner. need to send owners address to check once again
65     function _DESTROY_CONTRACT_(address _check) external onlyOwner{
66         require(_check == owner, "Enter owners address correctly");
67         selfdestruct(owner);
68     }
69 }