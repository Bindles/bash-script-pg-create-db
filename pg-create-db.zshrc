function pgcrdb() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: pgcreatedb <username> <password> <database_name>"
        return 1
    fi

	database="$1"
    username="$2"
    password="$3"

    sudo -u postgres psql -c "CREATE USER $username WITH PASSWORD '$password';" &&
    sudo -u postgres psql -c "CREATE DATABASE $database OWNER $username;" &&
    sudo -u postgres psql -c "ALTER USER $username CREATEDB;"

    if [ $? -eq 0 ]; then
        echo -n "Append to end of \033[0;93mconfig/database.yml\033[00m? (y/yes/ok to confirm, any other key will cancel): "
        read confirm
        case "$confirm" in
            [yY]|[yY][eE][sS]|[oO][kK])
                echo "database: '$database'" >> config/database.yml
                echo "username: '$username'" >> config/database.yml
                echo "password: '$password'" >> config/database.yml
                echo "Appended to config/database.yml. Don't forget to copy and paste it from the bottom to the proper matching location"
                ;;
            *)
                # Copy to xclip with newlines
                echo -e "$database\n$password\n$username" | xclip -selection clipboard
                echo "Cancelled write of \033[0;93mconfig/database.yml\033[00m credentials. Enjoy your new Postgres database. Ctrl+v for credentials."
                ;;
        esac
    fi
}