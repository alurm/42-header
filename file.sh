# Copyright (c) 2021, 2022 Alan Urmancheev <alan.urman@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# Prepend specified files with School 42 header.
# The header uses C style comments.
# Files may contain something, be empty or not exist at all.
# ``who'' and ``domain'' variables may be customized to suit your needs, e.g. if you're working from home.
# Example:
# 	who=ghelman
# 	domain=student.42.fr

# Username.
who=$(whoami)

# Email domain.
domain=student.$(hostname | rev | cut -f-2 -d. | rev)

# To-do: work for files with different comment styles, not just for C style.
# To-do: don't update ``Created'' field if it's already present. Assumption that file actual creation date is the same as OS says is usually incorrect.

set -eu

. "$(dirname "$0")/library.sh"

if [ "$#" -eq 0 ]; then
	usage
fi

for path; do
	file=$(basename "$path")

	updated=$(date "$dateFormat")

	if [ -e "$path" ]; then
		# shellcheck disable=SC2086 # Word splitting.
		created=$(date $dateEpochFlagsPrefix"$(stat $statBirthFlags "$path")" "$dateFormat")
	else
		created=$updated
	fi

	filePadding=$(padding '                                                   ' "$file")
	byPadding=$(padding '                                       ' "$who" "$who" "$domain")
	# createdPadding=$(padding '                  ' "$who")
	# updatedPadding=$(padding '                 ' "$who")
	createdPadding=$(padding '                                     ' "$created" "$who")
	# createdPadding=$(padding "${created}${who}")
	updatedPadding=$(padding '                                    ' "$updated" "$who")

	firstLineContent='/* ************************************************************************** */'

	header="\
$firstLineContent
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   $file$filePadding:+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: $who <$who@$domain>$byPadding+#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: $created by $who$createdPadding#+#    #+#             */
/*   Updated: $updated by $who$updatedPadding###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */"
	nHeaderLines=$(echo "$header" | wc -l)
	if [ -e "$path" ] || [ -L "$path" ]; then
		tmp=$(mktemp)
		echo "$header" > "$tmp"
		if hasHeader "$path"; then
			sed -n "$((nHeaderLines + 1))"',$p' "$path" >> "$tmp"
		else
			echo >> "$tmp"
			cat "$path" >> "$tmp"
		fi
		# Don't use mv. Mv deletes file's previous metadata.
		cp "$tmp" "$path"
		rm "$tmp"
	else
		echo "$header" > "$path"
	fi
done
