#!/bin/sh

prompt() {
	local var="$1"
	local text="$2"
	local default="$3"
	readonly default
	readonly var

	if [ ! -z "$default" ]; then
		text="$text [$default]"
	fi

	text="$text: "
	read -p "$text" $var

	if [ -z "${!var}" ]; then
		eval $var="'$default'"
	fi
}

prompt author_name "Substitute author name for" "$FULLNAME"
prompt author_email "Substitute author email for" "$EMAIL"
prompt vendor_name "Substitute vendor name for"
prompt module_name "Substitute module name for"
prompt project_name "Substitute project name for" "$vendor_name-$module_name"

for var in author_name author_email project_name vendor_name module_name; do
	eval "$var=\`echo '${!var}' | sed -e 's/[\\/&]/\\\\\\\\&/g'\`"
done


sed -i '' -e "s/@PROJECT_NAME@/$project_name/g" \
       	-e "s/@VENDOR_NAME@/$vendor_name/g" \
	-e "s/@AUTHOR_NAME@/$author_name/g" \
	-e "s/people@example.com/$author_email/g" \
	-e "s/@MODULE_NAME@/$module_name/g" \
	-e "s/gasolwu/$vendor_name/g" \
	-e "s/php-project-template/$module_name/g" composer.json build.xml phpunit.xml.dist
