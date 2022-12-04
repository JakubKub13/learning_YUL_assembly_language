object "Token" {
    code {
        // Store creator of the contract in slot zero
        sstore(0, caller())

        // Deploy the contract
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }
    object "runtime" {
        code {
            // Protection against sending ether
            require(iszero(callvalue()))

            // Dispatcher
            switch selector()
            case 0x70a08231 /** balanceOf(address) */ {
                returnUint(balanceOf(decodeAsAddress(0)))
            }
            case 0x18160ddd /** totalSupply() */ {
                returnUint(totalSupply())
            }
            case 0xa9059cbb /** transfer(address,uint256) */ {
                transfer(decodeAsAddress(0), decodeAsUnit(1))
                returnTrue()
            }
            case 0x23b872dd /** transferFrom(address,address,uint256) */ {
                transferFrom(decodeAsAddress(0), decodeAsAddress(1), decodeAsUint(2))
                returnTrue()
            }
            case 0x095ea7b3 /** approve(address,uint256) */ {
                approve(decodeAsAddress(0), decodeAsUint(1))
                returnTrue()
            }
            case 0xdd62ed3e /** allowance(address,address) */ {
                returnUint(allowance(decodeAsAddress(0), decodeAsAddress(1)))
            }
            case 0x40c10f19 /** mint(address,uint256) */ {
                mint(decodeAsAddress(0), decodeAsUint(1))
                returnTrue()
            }
        }
    }
}