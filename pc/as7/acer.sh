linkAcerCenter="https://global-download.acer.com/GDFiles/Application/Acer%20Care%20Center/Acer%20Care%20Center_Acer_4.00.3046_W11x64_A.zip?acerid=638115973251364975&Step1=&Step2=&Step3=ASPIRE%20A715-42G&OS=ALL&LC=en&BC=ACER&SC=PA_6"
linkAcerQuickAccess="https://global-download.acer.com/GDFiles/Application/Quick%20Access/Quick%20Access_Acer_3.00.3044_W11x64_A.zip?acerid=638115974807159857&Step1=&Step2=&Step3=ASPIRE%20A715-42G&OS=ALL&LC=en&BC=ACER&SC=PA_6"
linkAudioDriver="https://global-download.acer.com/GDFiles/Driver/Audio/Audio_Realtek_6.0.9208.1_W11x64_A.zip?acerid=637734066224533681&Step1=&Step2=&Step3=ASPIRE%20A715-42G&OS=ALL&LC=en&BC=ACER&SC=PA_6"
linkNitroSense="https://global-download.acer.com/GDFiles/Application/Nitro%20Sense/Nitro%20Sense_Acer_3.01.3028_W11x64_A.zip?acerid=637813743040356772&Step1=&Step2=&Step3=NITRO%20AN515-55&OS=ALL&LC=en&BC=ACER&SC=PA_6"

download_external AcerCare.zip $linkAcerCenter
download_external AcerQuickAccess.zip $linkAcerQuickAccess
download_external NitroSense.zip $linkNitroSense
download_external AudioDriver.zip $linkAudioDriver
extract *.zip

NITRO="$(get_extract_folder *.zip)/Nitro Sense_Acer_3.01.3028_W11x64/NitroSense_V3.01.3028_MSFT_SIGNED_20210812"

mv "$NITRO/Plugs/Nitro AN515-42" "$NITRO/Plugs/Aspire A715-42G" 

gsudo -n "$(get_extract_folder *.zip)/Acer Care Center_Acer_4.00.3046_W11x64/Setup.exe"
gsudo -n "$(get_extract_folder *.zip)/Quick Access_Acer_3.00.3044_W11x64/Setup.exe"
gsudo -n "$NITRO/Setup.exe"
gsudo -n "$(get_extract_folder *.zip)/Audio_Realtek_6.0.9208.1_W11x64/Setup_Driver.cmd"