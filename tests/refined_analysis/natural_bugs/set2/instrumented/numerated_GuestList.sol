1 //SPDX-License-Identifier: Unlicense
2 pragma solidity 0.7.3;
3 
4 interface GuestList {
5     function invite_guest(address) external;
6     function authorized(address, uint) external view returns (bool);
7 }