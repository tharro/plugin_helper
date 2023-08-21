import 'package:flutter/material.dart';
import 'package:plugin_helper/widgets/phone_number/intl_phone_number_input.dart';
import 'package:plugin_helper/widgets/phone_number/intl_phone_number_input_test.dart';
import 'package:plugin_helper/widgets/phone_number/src/models/country_model.dart';
import 'package:plugin_helper/widgets/phone_number/src/widgets/countries_search_list_widget.dart';
import 'package:plugin_helper/widgets/phone_number/src/widgets/item.dart';

/// [SelectorButton]
class SelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country? country;
  final SelectorConfig selectorConfig;
  final TextStyle? selectorTextStyle;
  final InputDecoration? searchBoxDecoration;
  final Widget? iconClose;
  final bool autoFocusSearchField;
  final String? locale;
  final bool isEnabled;
  final bool isScrollControlled;
  final ValueChanged<Country?> onCountryChanged;

  const SelectorButton({
    Key? key,
    required this.countries,
    required this.country,
    required this.selectorConfig,
    required this.selectorTextStyle,
    required this.searchBoxDecoration,
    required this.autoFocusSearchField,
    required this.locale,
    required this.onCountryChanged,
    required this.isEnabled,
    required this.isScrollControlled,
    this.iconClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectorConfig.selectorType == PhoneInputSelectorType.DROPDOWN
        ? countries.isNotEmpty && countries.length > 1
            ? DropdownButtonHideUnderline(
                child: DropdownButton<Country>(
                  key: const Key(TestHelper.DropdownButtonKeyValue),
                  hint: Item(
                      height: selectorConfig.height,
                      width: selectorConfig.width,
                      radius: selectorConfig.radius,
                      country: country,
                      showFlag: selectorConfig.showFlags,
                      useEmoji: selectorConfig.useEmoji,
                      iconRight: selectorConfig.iconRight,
                      iconLeft: selectorConfig.iconLeft,
                      flagPadding: selectorConfig.flagPadding,
                      textStyle: selectorTextStyle,
                      heightItem: selectorConfig.heightItem),
                  value: country,
                  items: mapCountryToDropdownItem(countries),
                  onChanged: isEnabled ? onCountryChanged : null,
                ),
              )
            : Item(
                height: selectorConfig.height,
                width: selectorConfig.width,
                radius: selectorConfig.radius,
                country: country,
                showFlag: selectorConfig.showFlags,
                useEmoji: selectorConfig.useEmoji,
                iconRight: selectorConfig.iconRight,
                iconLeft: selectorConfig.iconLeft,
                flagPadding: selectorConfig.flagPadding,
                textStyle: selectorTextStyle,
                heightItem: selectorConfig.heightItem)
        : MaterialButton(
            key: const Key(TestHelper.DropdownButtonKeyValue),
            padding: EdgeInsets.zero,
            minWidth: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: countries.isNotEmpty && countries.length > 1 && isEnabled
                ? () async {
                    Country? selected;
                    if (selectorConfig.selectorType ==
                        PhoneInputSelectorType.BOTTOM_SHEET) {
                      selected = await showCountrySelectorBottomSheet(
                          context, countries);
                    } else {
                      selected =
                          await showCountrySelectorDialog(context, countries);
                    }

                    if (selected != null) {
                      onCountryChanged(selected);
                    }
                  }
                : null,
            child: Item(
                height: selectorConfig.height,
                width: selectorConfig.width,
                radius: selectorConfig.radius,
                country: country,
                showFlag: selectorConfig.showFlags,
                useEmoji: selectorConfig.useEmoji,
                textStyle: selectorTextStyle,
                boxDecoration: selectorConfig.boxDecoration,
                iconRight: selectorConfig.iconRight,
                iconLeft: selectorConfig.iconLeft,
                flagPadding: selectorConfig.flagPadding,
                heightItem: selectorConfig.heightItem),
          );
  }

  /// Converts the list [countries] to `DropdownMenuItem`
  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(
      List<Country> countries) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: Item(
          key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
          country: country,
          height: selectorConfig.height,
          width: selectorConfig.width,
          radius: selectorConfig.radius,
          showFlag: selectorConfig.showFlags,
          useEmoji: selectorConfig.useEmoji,
          textStyle: selectorTextStyle,
          withCountryNames: false,
          boxDecoration: selectorConfig.boxDecoration,
          iconRight: selectorConfig.iconRight,
          iconLeft: selectorConfig.iconLeft,
          flagPadding: selectorConfig.flagPadding,
          heightItem: selectorConfig.heightItem,
        ),
      );
    }).toList();
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.DIALOG] is selected
  Future<Country?> showCountrySelectorDialog(
      BuildContext context, List<Country> countries) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: CountrySearchListWidget(
            countries,
            locale,
            searchBoxDecoration: searchBoxDecoration,
            showFlags: selectorConfig.showFlags,
            useEmoji: selectorConfig.useEmoji,
            autoFocus: autoFocusSearchField,
            iconClose: iconClose,
          ),
        ),
      ),
    );
  }

  /// shows a Dialog with list [countries] if the [PhoneInputSelectorType.BOTTOM_SHEET] is selected
  Future<Country?> showCountrySelectorBottomSheet(
      BuildContext context, List<Country> countries) {
    return showModalBottomSheet(
      context: context,
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (BuildContext context) {
        return Stack(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
          ),
          DraggableScrollableSheet(
            builder: (BuildContext context, ScrollController controller) {
              return Container(
                decoration: ShapeDecoration(
                  color: Theme.of(context).canvasColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                ),
                child: CountrySearchListWidget(
                  countries,
                  locale,
                  searchBoxDecoration: searchBoxDecoration,
                  scrollController: controller,
                  showFlags: selectorConfig.showFlags,
                  useEmoji: selectorConfig.useEmoji,
                  autoFocus: autoFocusSearchField,
                  iconClose: iconClose,
                ),
              );
            },
          ),
        ]);
      },
    );
  }
}
