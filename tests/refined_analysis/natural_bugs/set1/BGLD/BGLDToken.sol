// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BGLDToken is ERC20("BAG Gold", "BGLD"), Ownable {
  function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }
}