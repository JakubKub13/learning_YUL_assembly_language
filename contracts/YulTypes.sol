//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract YulTypes {
    // Yul has only one type bytes32 -> 256 bits
    function getNumber() external pure returns (uint256) {
        uint256 x;

        assembly {
            x := 42
        }
        return x;
    }

    function getHex() external pure returns (uint256) {
        uint256 x;

        assembly {
            x := 0xa // 10
        }
        return x;
    }

    function demoString() external pure returns (string memory) {
        bytes32 myString = "";

        assembly {
            myString := "Hello Yul"
        }

        return string(abi.encode(myString));
    }

    function representation() external pure returns (address) {
        address x;

        assembly {
            x := 1
        }

        return x;
    }
    
}