#!/usr/bin/bash

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# Base folder for databases
DB_DIR="./Databases"
mkdir -p "$DB_DIR"

# Main loop
while true; do
    echo -e "\n${YELLOW}--- Main Menu ---${RESET}"
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Connect to Database"
    echo "4) Drop Database"
    echo "5) Exit"
    read -p "Enter choice: " main_choice

    case $main_choice in
        1)  # Create Database
            read -p "Enter Database Name: " db_name
            if [[ -z "$db_name" || "$db_name" =~ [[:space:]] || ! "$db_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
                echo -e "${RED}Invalid name!${RESET}"
            elif [[ -d "$DB_DIR/$db_name" ]]; then
                echo -e "${RED}Database already exists!${RESET}"
            else
                mkdir "$DB_DIR/$db_name"
                echo -e "${GREEN}Database '$db_name' created.${RESET}"
            fi
            ;;
        2)  # List Databases
            echo -e "${YELLOW}Databases:${RESET}"
            ls "$DB_DIR"
            ;;
        3)  # Connect to Database
            read -p "Enter Database Name: " db_name
            if [[ ! -d "$DB_DIR/$db_name" ]]; then
                echo -e "${RED}Database does not exist.${RESET}"
            else
                active_db="$DB_DIR/$db_name"
                echo -e "${GREEN}Connected to '$db_name'.${RESET}"

                # Submenu for table management
                while true; do
                    echo -e "\n${YELLOW}--- Tables Menu [$db_name] ---${RESET}"
                    echo "1) Create Table"
                    echo "2) List Tables"
                    echo "3) Drop Table"
                    echo "4) Insert Row"
                    echo "5) Select Rows"
                    echo "6) Delete Row"
                    echo "7) Update Row"
                    echo "8) Back to Main Menu"
                    read -p "Enter choice: " table_choice

                    case $table_choice in
                        1)  # Create Table
                                    read -p "Enter Table Name: " table_name

                                    if [[ -z "$table_name" || "$table_name" =~ [[:space:]] || ! "$table_name" =~ ^[a-zA-Z0-9_]+$ ]]; then
                                        echo -e "${RED}Invalid table name!${RESET}"
                                    elif [[ -f "$active_db/$table_name" ]]; then
                                        echo -e "${RED}Table already exists!${RESET}"
                                    else
                                        read -p "Enter number of columns: " col_count
                                        if ! [[ "$col_count" =~ ^[1-9][0-9]*$ ]]; then
                                            echo -e "${RED}Invalid number of columns.${RESET}"
                                        else
                                            schema=""
                                            for ((i=1; i<=col_count; i++)); do
                                                read -p "Enter name for column $i: " col_name
                                                echo "Select type for column $i:"
                                                select col_type in "int" "string"; do
                                                    if [[ "$col_type" == "int" || "$col_type" == "string" ]]; then
                                                        break
                                                    fi
                                                done
                                                schema+="$col_name:$col_type,"
                                            done
                                            echo "${schema%,}" > "$active_db/$table_name"
                                            echo -e "${GREEN}Table '$table_name' created successfully.${RESET}"
                                        fi
                                    fi
                                ;;
                        2)  # List Tables
                            echo -e "${YELLOW}Tables:${RESET}"
                            ls "$active_db"
                            ;;
                        3)  # Drop Table
                            read -p "Enter Table Name: " table_name
                            if [[ -f "$active_db/$table_name" ]]; then
                                rm "$active_db/$table_name"
                                echo -e "${GREEN}Table '$table_name' dropped.${RESET}"
                            else
                                echo -e "${RED}Table not found.${RESET}"
                            fi
                            ;;
                        4)  # Insert Row
                            read -p "Enter Table Name: " table_name
                            if [[ ! -f "$active_db/$table_name" ]]; then
                                echo -e "${RED}Table not found.${RESET}"
                            else
                                schema=$(head -n 1 "$active_db/$table_name")
                                row_data=""
                                IFS=',' read -ra schema_cols <<< "$schema"
                                for col in "${schema_cols[@]}"; do
                                    col_name=$(echo $col | cut -d: -f1)
                                    col_type=$(echo $col | cut -d: -f2)
                                    read -p "Enter value for $col_name ($col_type): " col_value
                                    row_data+="$col_value,"
                                done
                                echo "${row_data%,}" >> "$active_db/$table_name"
                                echo -e "${GREEN}Row inserted.${RESET}"
                            fi
                            ;;
                        5)  # Select Rows
                            read -p "Enter Table Name: " table_name
                            if [[ -f "$active_db/$table_name" ]]; then
                                echo -e "${YELLOW}Contents of $table_name:${RESET}"
                                cat "$active_db/$table_name"
                            else
                                echo -e "${RED}Table not found.${RESET}"
                            fi
                            ;;
                        6)  # Delete Row
                            read -p "Enter Table Name: " table_name
                            if [[ -f "$active_db/$table_name" ]]; then
                                cat -n "$active_db/$table_name"
                                read -p "Enter line number to delete: " line_no
                                sed -i "${line_no}d" "$active_db/$table_name"
                                echo -e "${GREEN}Row deleted.${RESET}"
                            else
                                echo -e "${RED}Table not found.${RESET}"
                            fi
                            ;;
                        7)  # Update Row
                            read -p "Enter Table Name: " table_name
                            if [[ -f "$active_db/$table_name" ]]; then
                                cat -n "$active_db/$table_name"
                                read -p "Enter row number to update: " line_no
                                schema=$(head -n 1 "$active_db/$table_name")
                                new_row=""
                                IFS=',' read -ra schema_cols <<< "$schema"
                                for col in "${schema_cols[@]}"; do
                                    col_name=$(echo $col | cut -d: -f1)
                                    col_type=$(echo $col | cut -d: -f2)
                                    read -p "Enter new value for $col_name ($col_type): " col_value
                                    new_row+="$col_value,"
                                done
                                sed -i "${line_no}s/.*/${new_row%,}/" "$active_db/$table_name"
                                echo -e "${GREEN}Row updated.${RESET}"
                            else
                                echo -e "${RED}Table not found.${RESET}"
                            fi
                            ;;
                        8)  break ;;
                        *)  echo -e "${RED}Invalid choice.${RESET}" ;;
                    esac
                done
            fi
            ;;
        4)  # Drop Database
            read -p "Enter Database Name: " db_name
            if [[ -d "$DB_DIR/$db_name" ]]; then
                rm -r "$DB_DIR/$db_name"
                echo -e "${GREEN}Database '$db_name' dropped.${RESET}"
            else
                echo -e "${RED}Database not found.${RESET}"
            fi
            ;;
        5)  echo -e "${GREEN}Goodbye!${RESET}"; exit ;;
        *)  echo -e "${RED}Invalid choice.${RESET}" ;;
    esac
done
