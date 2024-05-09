pragma solidity 0.4.25;

/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
contract IDAP {
  function transfer(address to, uint256 value) public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);

  function transferFrom(address from, address to, uint256 value) public returns (bool);

  function balanceOf(address who) public view returns (uint256);

  function allowance(address owner, address spender) public view returns (uint256);

  function burn(uint _amount) public;

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract SwapIn {
  IDAP public dapToken = IDAP(0x780ec47d3696Fe6fc8Cd273D2420721bCEf936c5);

  event SwapIn(address user, string receiver, uint amount);

  function swapIn(string receiver) public {
    uint userBalance = dapToken.balanceOf(msg.sender);
    require(dapToken.transferFrom(msg.sender, address(0x0), userBalance), 'Burn token failed');
    emit SwapIn(msg.sender, receiver, userBalance);
  }
}