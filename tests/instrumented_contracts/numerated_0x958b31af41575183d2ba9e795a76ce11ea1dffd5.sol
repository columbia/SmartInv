1 contract ERC20 {
2   function transfer(address _recipient, uint256 _value) public returns (bool success);
3 }
4 
5 contract Airdrop {
6   function drop(ERC20 token, address[] recipients, uint256[] values) public {
7     for (uint256 i = 0; i < recipients.length; i++) {
8       token.transfer(recipients[i], values[i]);
9     }
10   }
11 }