1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   function allowance(address owner, address spender) public view returns (uint256);
10   function transferFrom(address from, address to, uint256 value) public returns (bool);
11 }
12 
13 
14 contract SeparateDistribution {
15   // The token interface
16   ERC20 public token;
17 
18   // The address of token holder that allowed allowance to contract
19   address public tokenWallet;
20 
21   constructor() public
22    {
23     token = ERC20(0xF3336E5DC23b01758CF03F6d4709D46AbA35a6Bd);
24     tokenWallet =  address(0xc45e9c64eee1F987F9a5B7A8E0Ad1f760dEFa7d8);  
25     
26   }
27   
28   function addExisitingContributors(address[] _address, uint256[] tokenAmount) public {
29         require (msg.sender == address(0xc45e9c64eee1F987F9a5B7A8E0Ad1f760dEFa7d8));
30         for(uint256 a=0;a<_address.length;a++){
31             if(!token.transferFrom(tokenWallet,_address[a],tokenAmount[a])){
32                 revert();
33             }
34         }
35     }
36     
37     function updateTokenAddress(address _address) external {
38         require(_address != 0x00);
39         token = ERC20(_address);
40     }
41 }