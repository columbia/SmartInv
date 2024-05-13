1 pragma solidity ^0.5.0;
2 
3 import "./../../../libs/token/ERC20/ERC20Detailed.sol";
4 import "./../../../libs/GSN/Context.sol";
5 import "./../../../libs/token//ERC20/ERC20.sol";
6 import "./../../../libs/math/SafeMath.sol";
7 
8 contract OEP4Template is Context, ERC20, ERC20Detailed {
9     address public Operator;
10     address public proxyHash;
11     constructor (address proxyContractAddress) public ERC20Detailed("OEP4 Template", "OEP4T", 9) {
12         _mint(address(this), 10000 * 10 ** 9);
13         Operator = _msgSender();
14         proxyHash = proxyContractAddress;
15     }
16     
17     modifier onlyOperator() {
18         require(_msgSender() == Operator, "Only Operator has access!");
19         _;
20     }
21     
22     function deletageToProxy(address _proxyHash, uint256 _amount) onlyOperator public returns (bool) {
23         if (proxyHash != address(0)) {
24             require(_proxyHash == proxyHash, "proxy contract address cannot be changed!");
25         } else {
26             proxyHash = _proxyHash;
27         }
28         require(this.transfer(_proxyHash, _amount), "transfer token to proxy contract failed!");
29         return true;
30         
31     }
32 }