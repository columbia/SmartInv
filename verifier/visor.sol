pragma solidity ^0.5.0;

import "./Libraries/IERC20.sol";
import "./SafeMath.sol";
import "./Libraries/VeriSolContracts.sol";
//import "./Libraries/Lib.sol";


contract simplifiedVisor is IERC20{
  IERC20 myToken;
  IERC20 token0;
  IERC20 token1; 
  address to; 
  uint ceil;
  uint price; 
  //pirce = token0.balanceOf(address(this))/token1.balanceOf(address(this));

  function liquidate(uint ceil) public {
    uint tokenPrice = getPrice(); 
    assert(tokenPrice <= 2 * VeriSol.Old(price)); 
    if (tokenPrice >= ceil){
      myToken.transfer(to, 30);
    }    
  }

  function getPrice() public returns (uint) {   
    uint price = token0.balanceOf(address(this))/token1.balanceOf(address(this));
    return price;
  }  
}