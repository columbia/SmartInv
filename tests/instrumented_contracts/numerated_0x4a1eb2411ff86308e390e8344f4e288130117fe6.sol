1 pragma solidity >0.4.99 <0.6.0;
2 
3 interface SlidebitsToken {
4     function frozenAccount(address tokenHolder) external returns (bool status);
5     function balanceOf(address _owner) external view returns (uint balance);
6 }
7 
8 interface token {
9     function transfer(address _to, uint256 _value) external;
10 }
11 
12 contract UpgradeToken {
13    address public owner;
14 
15    modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20   address oldTokenAddress = 0xb7FE7B2B723020Cf668Db4F78992d10F81990fc4;
21   address newTokenAddress = 0x46706C5e5B7dF0Afd54a7248F1E5788275B7FaC6;
22 
23   SlidebitsToken public oldToken = SlidebitsToken(oldTokenAddress);
24   token public newToken = token(newTokenAddress);
25 
26   mapping (address => bool) public upgradedAccount;
27   
28   constructor() public {
29     owner = msg.sender;
30   }
31 
32   function upgradeFrozenAccounts(address[] memory tokenHolders) public onlyOwner {
33     for(uint i = 0; i < tokenHolders.length; i++)
34     {
35       if (oldToken.frozenAccount(tokenHolders[i]) && !upgradedAccount[tokenHolders[i]]){
36           upgradedAccount[tokenHolders[i]] = true;
37           newToken.transfer(tokenHolders[i], oldToken.balanceOf(tokenHolders[i]));
38       }
39     }
40   }
41 
42 }